import '../../domain/entities/schedule_content.dart';

/// Kontrak sumber data Jadwal.
abstract interface class ScheduleDataSource {
  Future<ScheduleContent> fetchScheduleContent();
}
