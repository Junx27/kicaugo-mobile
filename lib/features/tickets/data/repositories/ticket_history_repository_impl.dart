import '../../domain/entities/ticket_history_content.dart';
import '../../domain/repositories/ticket_history_repository.dart';
import '../datasources/ticket_history_data_source.dart';

class TicketHistoryRepositoryImpl implements TicketHistoryRepository {
  const TicketHistoryRepositoryImpl(this._dataSource);

  final TicketHistoryDataSource _dataSource;

  @override
  Future<TicketHistoryContent> fetchTicketHistory() =>
      _dataSource.fetchTicketHistory();
}
