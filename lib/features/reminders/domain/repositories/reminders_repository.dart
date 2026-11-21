import '../entities/reminders_content.dart';

/// Kontrak data halaman pengingat rawatan dan alarm lomba.
abstract class RemindersRepository {
  Future<RemindersContent> fetchReminders();
}
