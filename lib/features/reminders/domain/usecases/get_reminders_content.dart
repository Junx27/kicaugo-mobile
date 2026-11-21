import '../entities/reminders_content.dart';
import '../repositories/reminders_repository.dart';

/// Pintu masuk Cubit untuk memuat data pengingat.
class GetRemindersContent {
  const GetRemindersContent(this._repository);

  final RemindersRepository _repository;

  Future<RemindersContent> call() => _repository.fetchReminders();
}
