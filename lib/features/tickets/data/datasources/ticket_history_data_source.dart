import '../../domain/entities/ticket_history_content.dart';

abstract class TicketHistoryDataSource {
  Future<TicketHistoryContent> fetchTicketHistory();
}
