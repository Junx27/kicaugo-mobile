import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/tickets_content.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/repositories/tickets_repository.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/usecases/get_tickets_content.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/pages/tickets_page.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/tickets_strings.dart';

import '../../support.dart';

/// Repository yang menunggu [completer] untuk menguji state loading.
class _PendingRepository implements TicketsRepository {
  _PendingRepository(this.completer);

  final Completer<TicketsContent> completer;

  @override
  Future<TicketsContent> fetchTickets() => completer.future;
}

/// Memasang halaman tiket di layar tinggi agar seluruh isi ter-render.
Future<void> _pumpTickets(
  WidgetTester tester, {
  GetTicketsContent getTickets = instantTickets,
}) async {
  tester.view.physicalSize = const Size(420, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: TicketsPage(getTickets: getTickets)),
    ),
  );
  // Sumber data demo memakai timer berdurasi nol; majukan waktu sedikit.
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump();
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pump();
}

void main() {
  testWidgets('menampilkan loading lalu konten', (tester) async {
    final completer = Completer<TicketsContent>();
    await _pumpTickets(
      tester,
      getTickets: GetTicketsContent(_PendingRepository(completer)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(demoTickets);
    await tester.pump();

    expect(find.text('#G-18'), findsOneWidget);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpTickets(
      tester,
      getTickets: GetTicketsContent(FlakyTicketsRepository()),
    );
    expect(find.text('Gagal memuat tiket'), findsOneWidget);

    await _tap(tester, AppConstants.retryLabel);
    await tester.pump();

    expect(find.text('#G-18'), findsOneWidget);
  });

  testWidgets('tab aktif menampilkan seluruh bagian', (tester) async {
    await _pumpTickets(tester);

    expect(find.text('${TicketsStrings.tabActive} (2)'), findsOneWidget);
    expect(find.text('${TicketsStrings.tabHistory} (5)'), findsOneWidget);
    expect(find.text('${TicketsStrings.tabCancelled} (1)'), findsOneWidget);
    expect(find.text('Piala Raja Nusantara 2026'), findsOneWidget);
    expect(find.text('${TicketsStrings.readyPrefix} (H-1)'), findsOneWidget);
    expect(find.text('KCG-2026-MRB-081928'), findsOneWidget);
    expect(find.text('#G-09'), findsOneWidget);
    expect(find.text('3 Podium'), findsOneWidget);
    expect(find.text('Ring Digital'), findsOneWidget);
    expect(find.text(TicketsStrings.historyTitle), findsOneWidget);
    expect(find.text('Juara 2 (Perak)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab riwayat dan dibatalkan', (tester) async {
    await _pumpTickets(tester);

    await _tap(tester, '${TicketsStrings.tabHistory} (5)');
    expect(find.text('Kenari Cup Pesanggrahan'), findsOneWidget);
    expect(find.text('#G-18'), findsNothing);

    await _tap(tester, '${TicketsStrings.tabCancelled} (1)');
    expect(find.text('Latber Cucak Ijo Malam'), findsOneWidget);
    expect(find.text(TicketsStrings.cancelled), findsOneWidget);
  });

  testWidgets('"Semua (5)" membuka tab riwayat', (tester) async {
    await _pumpTickets(tester);

    await _tap(tester, '${TicketsStrings.seeAll} (5)');

    expect(find.text('Kenari Cup Pesanggrahan'), findsOneWidget);
  });

  testWidgets('filter burung menyaring dan menampilkan keadaan kosong', (
    tester,
  ) async {
    await _pumpTickets(tester);

    await _tap(tester, 'Kacer');
    expect(find.text('#G-09'), findsOneWidget);
    expect(find.text('#G-18'), findsNothing);

    await _tap(tester, 'Cucak Hijau');
    expect(find.text(TicketsStrings.emptyTickets), findsOneWidget);
    expect(find.text('Festival Cucak Hijau Jakarta'), findsOneWidget);

    await _tap(tester, TicketsStrings.allBirds);
    expect(find.text('#G-18'), findsOneWidget);
  });

  final comingSoonTargets = <String, Finder Function()>{
    'filter': () => find.byTooltip(TicketsStrings.filterTooltip),
    'QR': () => find.text(TicketsStrings.openQr),
    'peta': () => find.text(TicketsStrings.paddockMap),
    'detail': () => find.text(TicketsStrings.ticketDetail),
    'sertifikat': () => find.text(TicketsStrings.certificate),
  };
  comingSoonTargets.forEach((name, finder) {
    testWidgets('$name menampilkan segera hadir', (tester) async {
      await _pumpTickets(tester);

      await tester.tap(finder());
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  });
}
