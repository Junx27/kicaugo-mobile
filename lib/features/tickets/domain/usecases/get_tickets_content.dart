import '../entities/tickets_content.dart';
import '../repositories/tickets_repository.dart';

/// Usecase untuk mengambil seluruh tiket pengguna.
class GetTicketsContent {
  const GetTicketsContent(this._repository);

  final TicketsRepository _repository;

  Future<TicketsContent> call() => _repository.fetchTickets();
}
