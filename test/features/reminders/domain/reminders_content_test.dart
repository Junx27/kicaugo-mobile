import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/entities/reminders_content.dart';

import '../reminders_fakes.dart';

void main() {
  test('ReminderBird menyusun label filter dan membandingkan props', () {
    const bird = ReminderBird(
      id: 'halilintar',
      name: 'Halilintar',
      species: 'Murai',
    );

    expect(bird.filterLabel, 'Halilintar (Murai)');
    expect(
      bird,
      const ReminderBird(
        id: 'halilintar',
        name: 'Halilintar',
        species: 'Murai',
      ),
    );
    expect(
      bird ==
          const ReminderBird(
            id: 'black-phantom',
            name: 'Halilintar',
            species: 'Murai',
          ),
      isFalse,
    );
  });

  test('CareReminder copyWith dan equality memuat seluruh properti', () {
    const reminder = CareReminder(
      id: 'care',
      birdId: 'halilintar',
      time: '06:00',
      title: 'Jemur',
      detail: '30 menit matahari pagi',
      kind: CareKind.sunlight,
    );

    expect(reminder.copyWith(), reminder);
    expect(reminder.copyWith(isDone: true).isDone, isTrue);
    expect(reminder.copyWith(alarmOn: false).alarmOn, isFalse);

    final done = reminder.copyWith(isDone: true);
    expect(done.title, reminder.title);
    expect(done.birdId, reminder.birdId);
    expect(done, isNot(reminder));

    expect(
      reminder ==
          const CareReminder(
            id: 'care',
            birdId: 'halilintar',
            time: '06:00',
            title: 'Jemur',
            detail: '30 menit matahari pagi',
            kind: CareKind.feeding,
          ),
      isFalse,
    );
    expect(
      reminder ==
          const CareReminder(
            id: 'care',
            birdId: 'halilintar',
            time: '06:00',
            title: 'Jemur',
            detail: '30 menit matahari pagi',
            kind: CareKind.sunlight,
            contestEveOnly: true,
          ),
      isFalse,
    );
  });

  test('ContestReminder copyWith dan equality memuat seluruh properti', () {
    const reminder = ContestReminder(
      id: 'h1',
      title: 'Pengingat H-1',
      detail: 'Siapkan kerodong',
    );

    expect(reminder.copyWith(), reminder);
    final off = reminder.copyWith(isOn: false);
    expect(off.isOn, isFalse);
    expect(off.title, reminder.title);
    expect(off.detail, reminder.detail);
    expect(off, isNot(reminder));
    expect(
      reminder ==
          const ContestReminder(
            id: 'h2',
            title: 'Pengingat H-1',
            detail: 'Siapkan kerodong',
          ),
      isFalse,
    );
  });

  test('ContestAlarm copyWith mempertahankan detail lomba', () {
    final contest = sampleReminders.contest;

    expect(contest.copyWith(), contest);
    final withoutReminders = contest.copyWith(reminders: const []);
    expect(withoutReminders.reminders, isEmpty);
    expect(withoutReminders.id, contest.id);
    expect(withoutReminders.title, contest.title);
    expect(withoutReminders.schedule, contest.schedule);
    expect(withoutReminders.venue, contest.venue);
    expect(withoutReminders.countdown, contest.countdown);
    expect(
      contest ==
          ContestAlarm(
            id: 'lain',
            title: contest.title,
            schedule: contest.schedule,
            venue: contest.venue,
            countdown: contest.countdown,
            reminders: contest.reminders,
          ),
      isFalse,
    );
  });

  test('ReminderSettings copyWith hanya mengubah getar', () {
    const settings = ReminderSettings(
      ringtone: 'Suara Masteran Cililin HD',
      vibrationOn: true,
    );

    expect(settings.copyWith(), settings);
    final silent = settings.copyWith(vibrationOn: false);
    expect(silent.vibrationOn, isFalse);
    expect(silent.ringtone, settings.ringtone);
    expect(
      settings ==
          const ReminderSettings(
            ringtone: 'Suara Masteran Cililin HD',
            vibrationOn: false,
          ),
      isFalse,
    );
  });

  test('RemindersContent copyWith mengganti bagian yang dipilih', () {
    const content = sampleReminders;

    expect(content.copyWith(), content);

    final emptyCare = content.copyWith(careReminders: const []);
    expect(emptyCare.careReminders, isEmpty);
    expect(emptyCare.birds, content.birds);

    final withoutReminders = content.copyWith(
      contest: content.contest.copyWith(reminders: const []),
    );
    expect(withoutReminders.contest.reminders, isEmpty);

    final silent = content.copyWith(
      settings: content.settings.copyWith(vibrationOn: false),
    );
    expect(silent.settings.vibrationOn, isFalse);

    expect(
      content ==
          RemindersContent(
            birds: const [],
            careReminders: content.careReminders,
            contest: content.contest,
            settings: content.settings,
          ),
      isFalse,
    );
  });
}
