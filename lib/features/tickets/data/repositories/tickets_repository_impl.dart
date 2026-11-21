import '../../domain/entities/tickets_content.dart';
import '../../domain/repositories/tickets_repository.dart';
import '../datasources/tickets_data_source.dart';

/// Implementasi [TicketsRepository] yang meneruskan ke sumber data.
class TicketsRepositoryImpl implements TicketsRepository {
  const TicketsRepositoryImpl(this._dataSource);

  final TicketsDataSource _dataSource;

  @override
  Future<TicketsContent> fetchTickets() => _dataSource.fetchTickets();
}
