import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/ticket_history_content.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/usecases/get_ticket_history_content.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/pages/ticket_history_page.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/ticket_history_strings.dart';

import '../../ticket_history_fakes.dart';

Future<void> _pumpPage(
  WidgetTester tester, {
  GetTicketHistoryContent getTicketHistory = instantTicketHistory,
}) async {
  tester.view.physicalSize = const Size(420, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: TicketHistoryPage(getTicketHistory: getTicketHistory),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump();
}

void main() {
  testWidgets('loading lalu menampilkan konten', (tester) async {
    final completer = Completer<TicketHistoryContent>();
    // import content type via fakes
    await _pumpPage(
      tester,
      getTicketHistory: GetTicketHistoryContent(
        PendingTicketHistoryRepository(completer),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(demoTicketHistory);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2));

    expect(find.text('Riwayat Tiket & Invoice'), findsWidgets);
    expect(find.text('Rp 3.850.000'), findsOneWidget);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpPage(
      tester,
      getTicketHistory: GetTicketHistoryContent(
        FlakyTicketHistoryRepository(failuresRemaining: 1),
      ),
    );
    expect(find.text('Gagal memuat riwayat tiket'), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2));

    expect(find.text('Rp 3.850.000'), findsOneWidget);
    expect(find.text('Gagal memuat riwayat tiket'), findsNothing);
  });

  testWidgets('filter mengubah tampilan grup', (tester) async {
    await _pumpPage(tester);
    await tester.tap(find.text('Selesai (5)'));
    await tester.pump();
    expect(find.text('April 2025 (Riwayat Selesai)'), findsOneWidget);
  });

  testWidgets('modal qr dan toast berfungsi', (tester) async {
    await _pumpPage(tester);
    await tester.tap(find.text('Lihat E-Tiket QR').first);
    await tester.pump();
    expect(find.text('GNT-PR25-0324'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    await tester.tap(find.text('Invoice PDF').first);
    await tester.pump();
    expect(find.textContaining('Mengunduh'), findsOneWidget);
  });

  testWidgets('menjelajahi semua filter dan tombol', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pump();

    for (final label in [
      'Lunas / Siap Gantang (2)',
      'Selesai (5)',
      'Dibatalkan / Refund (1)',
      'Semua (8)',
    ]) {
      await tester.tap(find.text(label));
      await tester.pump();
    }

    // Tombol-tombol utama.
    for (final label in [
      'Lihat E-Tiket QR',
      'Invoice PDF',
      'Lihat E-Tiket',
      'Bukti Bayar',
      'Cetak Piagam',
      'Rincian Invoice',
      'Rincian Invoice & Penjurian',
      'Lihat Bukti Refund Resmi',
    ]) {
      final finder = find.text(label);
      if (finder.evaluate().isNotEmpty) {
        await tester.tap(finder.first);
        await tester.pump();
        if (label == 'Lihat E-Tiket QR' || label == 'Lihat E-Tiket') {
          await tester.tap(find.text('Tutup Tampilan E-Tiket'));
          await tester.pump();
        }
      }
    }

    final filterScrollable = find.byType(Scrollable).last;
    await tester.drag(filterScrollable, const Offset(-400, 0));
    await tester.pump();
    await tester.tap(find.byKey(const Key('ticket_history_filter_refund')));
    await tester.pump();

    await tester.tap(find.text(TicketHistoryStrings.monthlyRecap));
    await tester.pump();
    expect(find.textContaining('Mengunduh'), findsOneWidget);
  });
}
