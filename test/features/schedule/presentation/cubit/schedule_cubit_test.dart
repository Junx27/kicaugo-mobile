import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/schedule_filter.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/schedule_region.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/usecases/get_schedule_content.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/cubit/schedule_state.dart';

import '../../schedule_fakes.dart';

void main() {
  final peak = DateTime(2026, 11, 22);
  final loaded = ScheduleState(
    status: ScheduleStatus.success,
    content: sampleSchedule,
    filter: ScheduleFilter(day: peak),
  );

  ScheduleCubit build([FakeScheduleRepository? repository]) =>
      ScheduleCubit(GetScheduleContent(repository ?? FakeScheduleRepository()));

  blocTest<ScheduleCubit, ScheduleState>(
    'memuat konten lalu memilih hari puncak',
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [const ScheduleState(status: ScheduleStatus.loading), loaded],
    verify: (cubit) => expect(cubit.state.visibleAgendas, hasLength(4)),
  );

  blocTest<ScheduleCubit, ScheduleState>(
    'gagal memuat mempertahankan filter dan alarm',
    build: () => build(FakeScheduleRepository(failuresRemaining: 1)),
    seed: () => const ScheduleState(
      filter: ScheduleFilter(region: ScheduleRegion.jawaBarat),
      alarmOn: false,
    ),
    act: (cubit) => cubit.load(),
    expect: () => const [
      ScheduleState(
        status: ScheduleStatus.loading,
        filter: ScheduleFilter(region: ScheduleRegion.jawaBarat),
        alarmOn: false,
      ),
      ScheduleState(
        status: ScheduleStatus.failure,
        message: 'Gagal memuat jadwal',
        filter: ScheduleFilter(region: ScheduleRegion.jawaBarat),
        alarmOn: false,
      ),
    ],
  );

  blocTest<ScheduleCubit, ScheduleState>(
    'filter wilayah, hari, dan kelas memperbarui daftar agenda',
    build: build,
    seed: () => loaded,
    act: (cubit) => cubit
      ..selectRegion(ScheduleRegion.jabodetabek)
      ..selectDay(DateTime(2026, 11, 19))
      ..selectCategory(BirdCategory.muraiBatu),
    verify: (cubit) {
      final titles = cubit.state.visibleAgendas.map((agenda) => agenda.title);
      expect(titles, ['Latber Eksklusif Malam Jumat']);
      expect(cubit.state.filter.region, ScheduleRegion.jabodetabek);
    },
  );

  blocTest<ScheduleCubit, ScheduleState>(
    'alarm bisa dimatikan',
    build: build,
    seed: () => loaded,
    act: (cubit) => cubit.setAlarm(false),
    expect: () => [loaded.withAlarm(false)],
  );

  test('tanpa konten tidak ada agenda', () {
    expect(const ScheduleState().visibleAgendas, isEmpty);
  });
}
