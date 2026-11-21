import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/schedule_content.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/usecases/get_schedule_content.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/pages/schedule_page.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/schedule_strings.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/widgets/schedule_chip_row.dart';

import '../../schedule_fakes.dart';

const _peakTitles = [
  'Batavia Cup Seri Nasional',
  'Latpres Minggu Ceria',
  'Bandung Kenari Open',
  'Piala Lawang Sewu Cup',
];

/// Memasang Jadwal di layar tinggi agar seluruh daftar ter-render.
Future<void> _pumpSchedule(
  WidgetTester tester, {
  ScheduleRepository? repository,
}) async {
  tester.view.physicalSize = const Size(420, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: SchedulePage(
          getScheduleContent: GetScheduleContent(
            repository ?? FakeScheduleRepository(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// Menggeser pita chip sampai [label] terlihat, lalu mengetuknya.
Future<void> _tapChip(WidgetTester tester, String label, int row) async {
  await tester.dragUntilVisible(
    find.text(label),
    find.byWidgetPredicate((widget) => widget is ScheduleChipRow).at(row),
    const Offset(-120, 0),
  );
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pump(const Duration(milliseconds: 600));
  await tester.tap(find.text(label));
  await tester.pump();
}

void _expectTitles(List<String> visible) {
  for (final title in _peakTitles) {
    expect(
      find.text(title),
      visible.contains(title) ? findsOneWidget : findsNothing,
      reason: title,
    );
  }
}

void main() {
  testWidgets('menampilkan loading lalu konten', (tester) async {
    final completer = Completer<ScheduleContent>();
    await _pumpSchedule(
      tester,
      repository: CompleterScheduleRepository(completer),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(sampleSchedule);
    await tester.pump();

    expect(find.text(ScheduleStrings.title), findsOneWidget);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpSchedule(
      tester,
      repository: FakeScheduleRepository(failuresRemaining: 1),
    );
    expect(find.text('Gagal memuat jadwal'), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(ScheduleStrings.title), findsOneWidget);
  });

  testWidgets('hari puncak menampilkan empat agenda dan seluruh bagian', (
    tester,
  ) async {
    await _pumpSchedule(tester);

    _expectTitles(_peakTitles);
    expect(find.text('4 ${ScheduleStrings.readySuffix}'), findsOneWidget);
    expect(find.text(ScheduleStrings.peakBadge), findsOneWidget);
    expect(find.text(ScheduleStrings.peakDay), findsOneWidget);
    expect(find.text('Jabodetabek (12)'), findsOneWidget);
    expect(find.text(sampleSchedule.featured.headline.title), findsOneWidget);
    expect(find.text('80% Terisi (Sisa 8 Tiket)'), findsOneWidget);
    expect(find.text(ScheduleStrings.alarmOn), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chip wilayah menyaring agenda', (tester) async {
    await _pumpSchedule(tester);

    await _tapChip(tester, 'Jawa Barat (8)', 0);

    _expectTitles(['Bandung Kenari Open']);
    expect(find.text('1 ${ScheduleStrings.readySuffix}'), findsOneWidget);
  });

  testWidgets('memilih hari lain mengganti agenda dan label puncak', (
    tester,
  ) async {
    await _pumpSchedule(tester);

    await tester.tap(find.text('19'));
    await tester.pump();

    _expectTitles(const []);
    expect(find.text('Latber Eksklusif Malam Jumat'), findsOneWidget);
    expect(find.text(ScheduleStrings.peakDay), findsNothing);
  });

  testWidgets('chip kelas menyaring dan bisa kosong', (tester) async {
    await _pumpSchedule(tester);

    await _tapChip(tester, 'Kenari', 1);
    _expectTitles(['Bandung Kenari Open']);

    await _tapChip(tester, 'Lovebird', 1);
    expect(find.text(ScheduleStrings.emptyAgenda), findsOneWidget);
    expect(find.text('0 ${ScheduleStrings.readySuffix}'), findsOneWidget);
  });

  testWidgets('alarm kalender bisa dimatikan', (tester) async {
    await _pumpSchedule(tester);

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.text(ScheduleStrings.alarmOff), findsOneWidget);
  });

  final comingSoonTargets = <String, Finder Function()>{
    'kalender': () => find.byTooltip(ScheduleStrings.calendarTooltip),
    'cari': () => find.text(ScheduleStrings.searchHint),
    'kalender lengkap': () => find.text(ScheduleStrings.fullCalendar),
    'pesan tiket': () => find.text(ScheduleStrings.bookNow),
    'filter eo': () => find.text(ScheduleStrings.filterOrganizer),
    'pilih sesi': () => find.text('Pilih Sesi').first,
    'peta': () => find.text(ScheduleStrings.mapTitle),
  };
  comingSoonTargets.forEach((name, finder) {
    testWidgets('$name menampilkan segera hadir', (tester) async {
      await _pumpSchedule(tester);

      await tester.tap(finder());
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  });
}
