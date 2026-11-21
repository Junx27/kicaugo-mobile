import 'package:equatable/equatable.dart';

import '../../domain/entities/reminders_content.dart';

/// Status pemuatan halaman pengingat.
enum RemindersStatus { initial, loading, success, failure }

/// State yang dibaca halaman pengingat.
class RemindersState extends Equatable {
  const RemindersState({
    this.status = RemindersStatus.initial,
    this.content,
    this.message,
    this.selectedBirdId,
  });

  final RemindersStatus status;
  final RemindersContent? content;
  final String? message;

  /// `null` berarti semua gacoan.
  final String? selectedBirdId;

  /// Rawatan yang lolos filter burung saat ini.
  List<CareReminder> get visibleCareReminders {
    final items = content?.careReminders ?? const <CareReminder>[];
    final filter = selectedBirdId;
    if (filter == null) {
      return items;
    }
    return items.where((item) => item.birdId == filter).toList(growable: false);
  }

  int get doneCount => visibleCareReminders.where((item) => item.isDone).length;

  RemindersState copyWith({
    RemindersStatus? status,
    RemindersContent? content,
    String? message,
    String? selectedBirdId,
    bool clearBirdFilter = false,
  }) {
    return RemindersState(
      status: status ?? this.status,
      content: content ?? this.content,
      message: message ?? this.message,
      selectedBirdId: clearBirdFilter
          ? null
          : (selectedBirdId ?? this.selectedBirdId),
    );
  }

  @override
  List<Object?> get props => [status, content, message, selectedBirdId];
}
