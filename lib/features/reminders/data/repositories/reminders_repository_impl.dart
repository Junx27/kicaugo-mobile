import '../../domain/entities/reminders_content.dart';
import '../../domain/repositories/reminders_repository.dart';
import '../datasources/reminders_data_source.dart';

class RemindersRepositoryImpl implements RemindersRepository {
  const RemindersRepositoryImpl(this._dataSource);

  final RemindersDataSource _dataSource;

  @override
  Future<RemindersContent> fetchReminders() => _dataSource.fetchReminders();
}
