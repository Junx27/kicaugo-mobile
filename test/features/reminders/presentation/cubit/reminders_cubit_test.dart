import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/usecases/get_reminders_content.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/cubit/reminders_state.dart';

import '../../reminders_fakes.dart';

void main() {
  RemindersCubit buildCubit([FakeRemindersRepository? repository]) {
    return RemindersCubit(
      GetRemindersContent(repository ?? FakeRemindersRepository()),
    );
  }

  blocTest<RemindersCubit, RemindersState>(
    'memuat konten lalu success',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => const [
      RemindersState(status: RemindersStatus.loading),
      RemindersState(status: RemindersStatus.success, content: sampleReminders),
    ],
  );

  blocTest<RemindersCubit, RemindersState>(
    'gagal memuat menyimpan pesan',
    build: () => buildCubit(FakeRemindersRepository(failuresRemaining: 1)),
    act: (cubit) => cubit.load(),
    expect: () => const [
      RemindersState(status: RemindersStatus.loading),
      RemindersState(
        status: RemindersStatus.failure,
        message: remindersFailure,
      ),
    ],
  );

  test('selectBird memfilter rawatan dan null mengembalikan semua', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    cubit.selectBird('rawa-rontek');
    expect(cubit.state.selectedBirdId, 'rawa-rontek');
    expect(cubit.state.visibleCareReminders, hasLength(1));
    expect(cubit.state.visibleCareReminders.first.id, 'care-evening-ef');
    expect(cubit.state.doneCount, 0);

    cubit.selectBird(null);
    expect(cubit.state.selectedBirdId, isNull);
    expect(cubit.state.visibleCareReminders, hasLength(4));
    expect(cubit.state.doneCount, 2);
  });

  test('aksi pengingat diabaikan sebelum konten dimuat', () {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    final initial = cubit.state;

    cubit.selectBird('halilintar');
    cubit.toggleCareDone('care-morning-sun');
    cubit.toggleCareAlarm('care-morning-sun');
    cubit.toggleContestReminder('h1');
    cubit.toggleVibration();

    expect(cubit.state, initial);
    expect(cubit.state.visibleCareReminders, isEmpty);
    expect(cubit.state.doneCount, 0);
  });

  test('toggle rawatan mengubah status selesai dan alarm', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    cubit.toggleCareDone('care-evening-ef');
    expect(cubit.state.content!.careReminders, hasLength(4));
    expect(cubit.state.visibleCareReminders, hasLength(4));
    expect(cubit.state.doneCount, 3);
    expect(
      cubit.state.content!.careReminders
          .firstWhere((item) => item.id == 'care-evening-ef')
          .isDone,
      isTrue,
    );

    cubit.toggleCareDone('care-evening-ef');
    expect(cubit.state.doneCount, 2);

    cubit.toggleCareAlarm('care-eve-grooming');
    expect(
      cubit.state.content!.careReminders
          .firstWhere((item) => item.id == 'care-eve-grooming')
          .alarmOn,
      isFalse,
    );
    expect(
      cubit.state.content!.careReminders
          .firstWhere((item) => item.id == 'care-morning-ef')
          .alarmOn,
      isTrue,
    );
  });

  test('toggle pengingat lomba hanya mengubah baris yang dipilih', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    cubit.toggleContestReminder('h1');

    final contest = cubit.state.content!.contest;
    expect(contest.reminders.first.isOn, isFalse);
    expect(contest.reminders.last.isOn, isTrue);
    expect(contest.title, sampleReminders.contest.title);
    expect(contest.venue, sampleReminders.contest.venue);
  });

  test('toggle getar membalik preferensi suara', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    expect(cubit.state.content!.settings.vibrationOn, isTrue);
    cubit.toggleVibration();
    expect(cubit.state.content!.settings.vibrationOn, isFalse);
    expect(
      cubit.state.content!.settings.ringtone,
      sampleReminders.settings.ringtone,
    );
  });
}
