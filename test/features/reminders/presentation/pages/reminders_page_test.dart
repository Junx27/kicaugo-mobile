import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/entities/reminders_content.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/usecases/get_reminders_content.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/pages/reminders_page.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/reminders_strings.dart';

import '../../reminders_fakes.dart';

const Size _viewport = Size(420, 4200);
const Duration _frame = Duration(milliseconds: 2);
const Duration _navigation = Duration(milliseconds: 600);
const String _startMarker = 'start-marker';
const String _profileMarker = 'profile-marker';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(_frame);
}

Future<void> _pumpNavigation(WidgetTester tester) async {
  await tester.pump(_navigation);
  await tester.pump(_navigation);
}

void _configureView(WidgetTester tester) {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _pumpPage(
  WidgetTester tester, {
  GetRemindersContent getRemindersContent = instantReminders,
}) async {
  _configureView(tester);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: RemindersPage(getRemindersContent: getRemindersContent),
    ),
  );
  await _settle(tester);
}

Future<void> _pumpRoutedPage(
  WidgetTester tester, {
  bool withHistory = false,
}) async {
  _configureView(tester);

  final router = GoRouter(
    initialLocation: withHistory ? '/start' : AppRoutes.reminders,
    routes: [
      if (withHistory)
        GoRoute(
          path: '/start',
          builder: (context, state) => Scaffold(
            body: Center(
              child: TextButton(
                key: const Key('open_reminders'),
                onPressed: () => context.push(AppRoutes.reminders),
                child: const Text(_startMarker),
              ),
            ),
          ),
        ),
      GoRoute(
        path: AppRoutes.reminders,
        builder: (context, state) =>
            const RemindersPage(getRemindersContent: instantReminders),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const Scaffold(body: Text(_profileMarker)),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
  await _settle(tester);
}

void main() {
  testWidgets('menampilkan loading lalu seluruh konten pengingat', (
    tester,
  ) async {
    final completer = Completer<RemindersContent>();
    await _pumpPage(
      tester,
      getRemindersContent: GetRemindersContent(
        CompleterRemindersRepository(completer),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(sampleReminders);
    await _settle(tester);

    final contest = sampleReminders.contest;
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(RemindersStrings.title), findsOneWidget);
    expect(find.text(RemindersStrings.intro), findsOneWidget);
    expect(find.text(RemindersStrings.allBirds), findsOneWidget);
    expect(find.text(sampleReminders.birds.first.filterLabel), findsOneWidget);
    expect(find.text(RemindersStrings.contestActive), findsOneWidget);
    expect(find.text(contest.title), findsOneWidget);
    expect(find.text(contest.schedule), findsOneWidget);
    expect(find.text(contest.venue), findsOneWidget);
    expect(find.text(contest.countdown), findsOneWidget);
    for (final reminder in contest.reminders) {
      expect(find.text(reminder.title), findsOneWidget);
      expect(find.text(reminder.detail), findsOneWidget);
    }
    expect(find.text(RemindersStrings.careToday), findsOneWidget);
    expect(find.text(RemindersStrings.progress(2, 4)), findsOneWidget);
    expect(find.text(RemindersStrings.contestEve), findsOneWidget);
    for (final reminder in sampleReminders.careReminders) {
      expect(find.text(reminder.detail), findsOneWidget);
    }
    expect(find.text(sampleReminders.settings.ringtone), findsOneWidget);
    expect(find.text(RemindersStrings.ringtoneTitle), findsOneWidget);
    expect(find.text(RemindersStrings.play), findsOneWidget);
    expect(find.text(RemindersStrings.vibrationTitle), findsOneWidget);
    expect(find.text(RemindersStrings.createCare), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpPage(
      tester,
      getRemindersContent: GetRemindersContent(
        FakeRemindersRepository(failuresRemaining: 1),
      ),
    );

    expect(find.text(remindersFailure), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await _settle(tester);

    expect(find.text(RemindersStrings.careToday), findsOneWidget);
    expect(find.text(remindersFailure), findsNothing);
  });

  testWidgets('filter burung menyaring rawatan dan mengosongkan daftar', (
    tester,
  ) async {
    await _pumpPage(tester);

    await tester.drag(find.byType(ListView), const Offset(-320, 0));
    await tester.pump();
    await tester.tap(find.byKey(const Key('reminders_bird_rawa-rontek')));
    await tester.pump();

    expect(find.text(RemindersStrings.progress(0, 1)), findsOneWidget);
    expect(
      find.byKey(const Key('reminders_care_care-evening-ef')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('reminders_care_care-morning-sun')),
      findsNothing,
    );

    await tester.drag(find.byType(ListView), const Offset(320, 0));
    await tester.pump();
    await tester.tap(find.byKey(const Key('reminders_bird_all')));
    await tester.pump();

    expect(find.text(RemindersStrings.progress(2, 4)), findsOneWidget);

    await tester.tap(find.byKey(const Key('reminders_bird_black-phantom')));
    await tester.pump();

    expect(find.text(RemindersStrings.emptyCare), findsOneWidget);
    expect(find.text(RemindersStrings.progress(0, 0)), findsOneWidget);
  });

  testWidgets('checkbox dan alarm rawatan mengubah state halaman', (
    tester,
  ) async {
    await _pumpPage(tester);

    await tester.ensureVisible(
      find.byKey(const Key('reminders_care_done_care-evening-ef')),
    );
    await tester.tap(
      find.byKey(const Key('reminders_care_done_care-evening-ef')),
    );
    await tester.pump();

    expect(find.text(RemindersStrings.progress(3, 4)), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('reminders_care_done_care-evening-ef')),
    );
    await tester.pump();
    expect(find.text(RemindersStrings.progress(2, 4)), findsOneWidget);

    final alarmFinder = find.byKey(
      const Key('reminders_care_alarm_care-eve-grooming'),
    );
    await tester.ensureVisible(alarmFinder);
    await tester.tap(alarmFinder);
    await tester.pump();

    expect(tester.widget<Switch>(alarmFinder).value, isFalse);
  });

  testWidgets('toggle alarm lomba dan mode getar berubah di layar', (
    tester,
  ) async {
    await _pumpPage(tester);

    final contestFinder = find.byKey(const Key('reminders_contest_switch_h1'));
    await tester.ensureVisible(contestFinder);
    await tester.tap(contestFinder);
    await tester.pump();

    expect(tester.widget<Switch>(contestFinder).value, isFalse);

    final vibrationFinder = find.byKey(const Key('reminders_vibration'));
    await tester.ensureVisible(vibrationFinder);
    await tester.tap(vibrationFinder);
    await tester.pump();

    expect(tester.widget<Switch>(vibrationFinder).value, isFalse);
  });

  final comingSoonTargets = <String, Finder Function()>{
    'tambah pengingat': () => find.byKey(const Key('reminders_add')),
    'pengaturan': () => find.byKey(const Key('reminders_settings')),
    'tambah alarm': () => find.byKey(const Key('reminders_add_contest')),
    'putar nada': () => find.byKey(const Key('reminders_play_ringtone')),
    'buat pengingat': () => find.byKey(const Key('reminders_create')),
  };
  comingSoonTargets.forEach((name, finder) {
    testWidgets('$name menampilkan segera hadir', (tester) async {
      await _pumpPage(tester);

      await tester.ensureVisible(finder());
      await tester.tap(finder());
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  });

  testWidgets('tombol kembali mem-pop halaman saat ada riwayat', (
    tester,
  ) async {
    await _pumpRoutedPage(tester, withHistory: true);

    await tester.tap(find.byKey(const Key('open_reminders')));
    await _pumpNavigation(tester);

    expect(find.byType(RemindersPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('reminders_back')));
    await _pumpNavigation(tester);

    expect(find.text(_startMarker), findsOneWidget);
    expect(find.byType(RemindersPage), findsNothing);
  });

  testWidgets('tombol kembali menuju Profil tanpa riwayat', (tester) async {
    await _pumpRoutedPage(tester);

    await tester.tap(find.byKey(const Key('reminders_back')));
    await _pumpNavigation(tester);

    expect(find.text(_profileMarker), findsOneWidget);
    expect(find.byType(RemindersPage), findsNothing);
  });
}
