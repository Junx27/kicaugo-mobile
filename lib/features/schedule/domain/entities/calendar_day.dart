import 'package:equatable/equatable.dart';

import 'agenda.dart';

/// Satu hari pada strip kalender mingguan.
class CalendarDay extends Equatable {
  const CalendarDay({
    required this.date,
    required this.label,
    this.accent,
    this.isPeak = false,
  });

  final DateTime date;

  /// Ringkasan kegiatan (mis. "3 Event", "-").
  final String label;

  /// Warna sorotan hari; `null` berarti netral.
  final AgendaAccent? accent;

  /// Hari puncak lomba minggu ini.
  final bool isPeak;

  @override
  List<Object?> get props => [date, label, accent, isPeak];
}
