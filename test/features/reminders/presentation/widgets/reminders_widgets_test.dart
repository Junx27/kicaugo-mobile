import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/reminders_strings.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/widgets/care_schedule_section.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/widgets/contest_alarm_card.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/widgets/reminder_alert_settings.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/widgets/reminder_bird_filter.dart';

import '../../reminders_fakes.dart';

const Size _viewport = Size(420, 3200);

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('filter burung mengirim semua lalu burung terpilih', (
    tester,
  ) async {
    final selections = <String?>[];
    await _pump(
      tester,
      ReminderBirdFilter(
        birds: sampleReminders.birds,
        selectedBirdId: null,
        onSelected: (birdId) => selections.add(birdId),
      ),
    );

    expect(find.text(RemindersStrings.allBirds), findsOneWidget);
    expect(find.text(sampleReminders.birds.first.filterLabel), findsOneWidget);

    await tester.tap(find.byKey(const Key('reminders_bird_all')));
    await tester.drag(find.byType(ListView), const Offset(-320, 0));
    await tester.pump();
    expect(find.text(sampleReminders.birds.last.filterLabel), findsOneWidget);
    await tester.tap(find.byKey(const Key('reminders_bird_rawa-rontek')));

    expect(selections, [null, 'rawa-rontek']);
  });

  testWidgets('section rawatan menampilkan progres dan meneruskan aksi', (
    tester,
  ) async {
    final doneIds = <String>[];
    final alarmIds = <String>[];
    await _pump(
      tester,
      CareScheduleSection(
        reminders: sampleReminders.careReminders,
        doneCount: 2,
        onToggleDone: (id) => doneIds.add(id),
        onToggleAlarm: (id) => alarmIds.add(id),
      ),
    );

    expect(find.text(RemindersStrings.careToday), findsOneWidget);
    expect(find.text(RemindersStrings.progress(2, 4)), findsOneWidget);
    expect(find.text(RemindersStrings.contestEve), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
    expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
    expect(find.byIcon(Icons.restaurant_rounded), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));

    await tester.tap(
      find.byKey(const Key('reminders_care_done_care-evening-ef')),
    );
    await tester.tap(
      find.byKey(const Key('reminders_care_alarm_care-evening-ef')),
    );

    expect(doneIds, ['care-evening-ef']);
    expect(alarmIds, ['care-evening-ef']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('kartu selesai memakai ikon sesuai jenis rawatan', (
    tester,
  ) async {
    final reminders = [
      for (final item in sampleReminders.careReminders)
        item.copyWith(isDone: true),
    ];
    await _pump(
      tester,
      CareScheduleSection(
        reminders: reminders,
        doneCount: reminders.length,
        onToggleDone: (_) {},
        onToggleAlarm: (_) {},
      ),
    );

    expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
    expect(find.byIcon(Icons.restaurant_rounded), findsOneWidget);
    expect(find.byIcon(Icons.graphic_eq_rounded), findsOneWidget);
    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    expect(find.text(RemindersStrings.progress(4, 4)), findsOneWidget);
  });

  testWidgets('section rawatan kosong menampilkan pesan', (tester) async {
    await _pump(
      tester,
      CareScheduleSection(
        reminders: const [],
        doneCount: 0,
        onToggleDone: (_) {},
        onToggleAlarm: (_) {},
      ),
    );

    expect(find.text(RemindersStrings.emptyCare), findsOneWidget);
    expect(find.text(RemindersStrings.progress(0, 0)), findsOneWidget);
  });

  testWidgets('kartu alarm menampilkan detail dan meneruskan toggle', (
    tester,
  ) async {
    final toggled = <String>[];
    var addTaps = 0;
    final contest = sampleReminders.contest;

    await _pump(
      tester,
      ContestAlarmCard(
        contest: contest,
        onToggleReminder: (id) => toggled.add(id),
        onAddAlarm: () => addTaps++,
      ),
    );

    expect(find.text(RemindersStrings.contestActive), findsOneWidget);
    expect(find.text(contest.title), findsOneWidget);
    expect(find.text(contest.schedule), findsOneWidget);
    expect(find.text(contest.venue), findsOneWidget);
    expect(find.text(contest.countdown), findsOneWidget);
    for (final reminder in contest.reminders) {
      expect(find.text(reminder.title), findsOneWidget);
      expect(find.text(reminder.detail), findsOneWidget);
    }

    expect(
      tester
          .widget<Switch>(find.byKey(const Key('reminders_contest_switch_h1')))
          .value,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('reminders_contest_switch_h1')));
    await tester.tap(find.byKey(const Key('reminders_add_contest')));

    expect(toggled, ['h1']);
    expect(addTaps, 1);
  });

  testWidgets('pengaturan alarm memutar nada dan membalik getar', (
    tester,
  ) async {
    var plays = 0;
    final vibrations = <bool>[];

    await _pump(
      tester,
      ReminderAlertSettings(
        ringtone: 'Suara Masteran Cililin HD',
        vibrationOn: true,
        onPlayRingtone: () => plays++,
        onVibrationChanged: (value) => vibrations.add(value),
      ),
    );

    expect(find.text(RemindersStrings.ringtoneTitle), findsOneWidget);
    expect(find.text('Suara Masteran Cililin HD'), findsOneWidget);
    expect(find.text(RemindersStrings.vibrationTitle), findsOneWidget);
    expect(find.text(RemindersStrings.vibrationDetail), findsOneWidget);

    await tester.tap(find.byKey(const Key('reminders_play_ringtone')));
    await tester.tap(find.byKey(const Key('reminders_vibration')));

    expect(plays, 1);
    expect(vibrations, [false]);
  });
}
