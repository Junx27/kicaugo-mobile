import '../entities/schedule_content.dart';

/// Kontrak akses data Jadwal.
abstract interface class ScheduleRepository {
  Future<ScheduleContent> fetchScheduleContent();
}
