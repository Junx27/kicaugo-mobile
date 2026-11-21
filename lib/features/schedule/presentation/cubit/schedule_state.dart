import 'package:equatable/equatable.dart';

import '../../domain/entities/agenda.dart';
import '../../domain/entities/schedule_content.dart';
import '../../domain/entities/schedule_filter.dart';

/// Status pemuatan Jadwal.
enum ScheduleStatus { initial, loading, success, failure }

/// State halaman Jadwal: data, filter aktif, dan status alarm kalender.
class ScheduleState extends Equatable {
  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.content,
    this.message,
    this.filter = const ScheduleFilter(),
    this.alarmOn = true,
  });

  final ScheduleStatus status;
  final ScheduleContent? content;
  final String? message;
  final ScheduleFilter filter;
  final bool alarmOn;

  /// Agenda yang lolos filter wilayah, hari, dan kelas.
  List<Agenda> get visibleAgendas =>
      (content?.agendas ?? const <Agenda>[]).where(filter.matches).toList();

  ScheduleState withFilter(ScheduleFilter value) => ScheduleState(
    status: status,
    content: content,
    message: message,
    filter: value,
    alarmOn: alarmOn,
  );

  ScheduleState withAlarm(bool value) => ScheduleState(
    status: status,
    content: content,
    message: message,
    filter: filter,
    alarmOn: value,
  );

  @override
  List<Object?> get props => [status, content, message, filter, alarmOn];
}
