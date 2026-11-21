import '../../domain/entities/tickets_content.dart';

/// Kontrak sumber data tiket.
abstract interface class TicketsDataSource {
  Future<TicketsContent> fetchTickets();
}
