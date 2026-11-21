import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_reminders_content.dart';
import 'reminders_state.dart';

/// Memuat konten, memfilter burung, dan mengubah status lokal.
class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit(this._getRemindersContent) : super(const RemindersState());

  final GetRemindersContent _getRemindersContent;

  Future<void> load() async {
    emit(state.copyWith(status: RemindersStatus.loading));
    try {
      final content = await _getRemindersContent();
      emit(state.copyWith(status: RemindersStatus.success, content: content));
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: RemindersStatus.failure,
          message: failure.message,
        ),
      );
    }
  }

  /// `null` berarti tampilkan semua gacoan.
  void selectBird(String? birdId) {
    if (state.content == null) {
      return;
    }
    emit(
      state.copyWith(selectedBirdId: birdId, clearBirdFilter: birdId == null),
    );
  }

  void toggleCareDone(String reminderId) {
    final content = state.content;
    if (content == null) {
      return;
    }
    emit(
      state.copyWith(
        content: content.copyWith(
          careReminders: [
            for (final item in content.careReminders)
              if (item.id == reminderId)
                item.copyWith(isDone: !item.isDone)
              else
                item,
          ],
        ),
      ),
    );
  }

  void toggleCareAlarm(String reminderId) {
    final content = state.content;
    if (content == null) {
      return;
    }
    emit(
      state.copyWith(
        content: content.copyWith(
          careReminders: [
            for (final item in content.careReminders)
              if (item.id == reminderId)
                item.copyWith(alarmOn: !item.alarmOn)
              else
                item,
          ],
        ),
      ),
    );
  }

  void toggleContestReminder(String reminderId) {
    final content = state.content;
    if (content == null) {
      return;
    }
    final contest = content.contest.copyWith(
      reminders: [
        for (final item in content.contest.reminders)
          if (item.id == reminderId) item.copyWith(isOn: !item.isOn) else item,
      ],
    );
    emit(state.copyWith(content: content.copyWith(contest: contest)));
  }

  void toggleVibration() {
    final content = state.content;
    if (content == null) {
      return;
    }
    emit(
      state.copyWith(
        content: content.copyWith(
          settings: content.settings.copyWith(
            vibrationOn: !content.settings.vibrationOn,
          ),
        ),
      ),
    );
  }
}
