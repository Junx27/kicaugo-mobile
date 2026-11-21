import '../entities/tickets_content.dart';

/// Kontrak akses data tiket pengguna.
abstract interface class TicketsRepository {
  Future<TicketsContent> fetchTickets();
}
