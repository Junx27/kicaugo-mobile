import '../entities/ticket_history_content.dart';

abstract class TicketHistoryRepository {
  Future<TicketHistoryContent> fetchTicketHistory();
}
