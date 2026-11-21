import '../../domain/entities/schedule_content.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_data_source.dart';

/// Implementasi [ScheduleRepository] yang meneruskan ke sumber data.
class ScheduleRepositoryImpl implements ScheduleRepository {
  const ScheduleRepositoryImpl(this._dataSource);

  final ScheduleDataSource _dataSource;

  @override
  Future<ScheduleContent> fetchScheduleContent() =>
      _dataSource.fetchScheduleContent();
}
