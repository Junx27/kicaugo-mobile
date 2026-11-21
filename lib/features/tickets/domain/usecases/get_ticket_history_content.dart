import '../entities/ticket_history_content.dart';
import '../repositories/ticket_history_repository.dart';

class GetTicketHistoryContent {
  const GetTicketHistoryContent(this._repository);

  final TicketHistoryRepository _repository;

  Future<TicketHistoryContent> call() => _repository.fetchTicketHistory();
}
