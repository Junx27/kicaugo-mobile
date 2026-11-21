import '../entities/schedule_content.dart';
import '../repositories/schedule_repository.dart';

/// Usecase untuk mengambil seluruh konten Jadwal.
class GetScheduleContent {
  const GetScheduleContent(this._repository);

  final ScheduleRepository _repository;

  Future<ScheduleContent> call() => _repository.fetchScheduleContent();
}
