import '../../domain/entities/reminders_content.dart';

/// Sumber data halaman pengingat.
abstract class RemindersDataSource {
  Future<RemindersContent> fetchReminders();
}
