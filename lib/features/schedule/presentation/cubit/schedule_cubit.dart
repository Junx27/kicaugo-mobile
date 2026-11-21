import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/bird_category.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/schedule_region.dart';
import '../../domain/usecases/get_schedule_content.dart';
import 'schedule_state.dart';

/// Memuat Jadwal dan menyimpan filter serta status alarm.
class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this._getScheduleContent) : super(const ScheduleState());

  final GetScheduleContent _getScheduleContent;

  /// Memuat (ulang) konten; hari terpilih diatur ke hari puncak.
  Future<void> load() async {
    emit(
      ScheduleState(
        status: ScheduleStatus.loading,
        filter: state.filter,
        alarmOn: state.alarmOn,
      ),
    );
    try {
      final content = await _getScheduleContent();
      emit(
        ScheduleState(
          status: ScheduleStatus.success,
          content: content,
          filter: state.filter.withDay(content.peakDay),
          alarmOn: state.alarmOn,
        ),
      );
    } on Failure catch (failure) {
      emit(
        ScheduleState(
          status: ScheduleStatus.failure,
          message: failure.message,
          filter: state.filter,
          alarmOn: state.alarmOn,
        ),
      );
    }
  }

  void selectRegion(ScheduleRegion region) =>
      emit(state.withFilter(state.filter.withRegion(region)));

  void selectDay(DateTime day) =>
      emit(state.withFilter(state.filter.withDay(day)));

  void selectCategory(BirdCategory category) =>
      emit(state.withFilter(state.filter.withCategory(category)));

  void setAlarm(bool value) => emit(state.withAlarm(value));
}
