import 'package:equatable/equatable.dart';

import '../../../../core/entities/bird_category.dart';
import 'agenda.dart';
import 'schedule_region.dart';

/// Apakah [a] dan [b] jatuh pada tanggal kalender yang sama.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Kombinasi filter wilayah, hari, dan kelas burung.
class ScheduleFilter extends Equatable {
  const ScheduleFilter({
    this.region = ScheduleRegion.all,
    this.day,
    this.category = BirdCategory.all,
  });

  final ScheduleRegion region;

  /// Hari terpilih; `null` berarti semua hari.
  final DateTime? day;
  final BirdCategory category;

  ScheduleFilter withRegion(ScheduleRegion value) =>
      ScheduleFilter(region: value, day: day, category: category);

  ScheduleFilter withDay(DateTime value) =>
      ScheduleFilter(region: region, day: value, category: category);

  ScheduleFilter withCategory(BirdCategory value) =>
      ScheduleFilter(region: region, day: day, category: value);

  /// Apakah [agenda] lolos ketiga filter.
  bool matches(Agenda agenda) {
    final tags = agenda.tags;
    final regionOk = region == ScheduleRegion.all || tags.region == region;
    final dayOk = day == null || isSameDay(day!, agenda.slot.date);
    final categoryOk =
        category == BirdCategory.all || tags.category == category;
    return regionOk && dayOk && categoryOk;
  }

  @override
  List<Object?> get props => [region, day, category];
}
