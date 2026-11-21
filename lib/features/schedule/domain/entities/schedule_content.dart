import 'package:equatable/equatable.dart';

import 'agenda.dart';
import 'calendar_day.dart';
import 'featured_event.dart';
import 'schedule_region.dart';

/// Ringkasan lokasi dan periode yang ditampilkan di bagian atas Jadwal.
class ScheduleSummary extends Equatable {
  const ScheduleSummary({
    required this.location,
    required this.nearbyArenas,
    required this.monthLabel,
    required this.weekLabel,
    required this.mapDistance,
  });

  final String location;
  final int nearbyArenas;
  final String monthLabel;
  final String weekLabel;
  final String mapDistance;

  @override
  List<Object?> get props => [
    location,
    nearbyArenas,
    monthLabel,
    weekLabel,
    mapDistance,
  ];
}

/// Seluruh data halaman Jadwal.
class ScheduleContent extends Equatable {
  const ScheduleContent({
    required this.summary,
    required this.regions,
    required this.days,
    required this.featured,
    required this.agendas,
  });

  final ScheduleSummary summary;
  final List<RegionCount> regions;
  final List<CalendarDay> days;
  final FeaturedEvent featured;
  final List<Agenda> agendas;

  /// Tanggal hari puncak (pilihan awal strip kalender).
  DateTime get peakDay => days.firstWhere((day) => day.isPeak).date;

  @override
  List<Object?> get props => [summary, regions, days, featured, agendas];
}
