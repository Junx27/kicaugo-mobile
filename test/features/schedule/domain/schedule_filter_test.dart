import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/schedule_filter.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/schedule_region.dart';

import '../schedule_fakes.dart';

void main() {
  final batavia = sampleSchedule.agendas.first;

  test('isSameDay mengabaikan jam', () {
    expect(
      isSameDay(DateTime(2026, 11, 22, 9), DateTime(2026, 11, 22)),
      isTrue,
    );
    expect(isSameDay(DateTime(2026, 11, 22), DateTime(2026, 11, 21)), isFalse);
  });

  test('filter kosong meloloskan semua agenda', () {
    expect(
      sampleSchedule.agendas.every(const ScheduleFilter().matches),
      isTrue,
    );
  });

  test('wilayah, hari, dan kelas harus cocok semuanya', () {
    final filter = const ScheduleFilter()
        .withRegion(ScheduleRegion.jabodetabek)
        .withDay(DateTime(2026, 11, 22))
        .withCategory(BirdCategory.muraiBatu);

    expect(filter.matches(batavia), isTrue);
    expect(
      filter.withRegion(ScheduleRegion.jawaTimur).matches(batavia),
      isFalse,
    );
    expect(filter.withDay(DateTime(2026, 11, 19)).matches(batavia), isFalse);
    expect(filter.withCategory(BirdCategory.kacer).matches(batavia), isFalse);
  });
}
