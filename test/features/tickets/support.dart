import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/tickets/data/datasources/fake_tickets_data_source.dart';
import 'package:rumahkicau_mobile/features/tickets/data/repositories/tickets_repository_impl.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/tickets_content.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/repositories/tickets_repository.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/usecases/get_tickets_content.dart';

/// Data tiket demo yang dipakai seluruh test fitur tiket.
const TicketsContent demoTickets = FakeTicketsDataSource.content;

/// Usecase tiket demo tanpa jeda.
const GetTicketsContent instantTickets = GetTicketsContent(
  TicketsRepositoryImpl(FakeTicketsDataSource(delay: Duration.zero)),
);

/// Repository tiket yang gagal sejumlah [failuresRemaining] kali.
class FlakyTicketsRepository implements TicketsRepository {
  FlakyTicketsRepository({this.failuresRemaining = 1});

  int failuresRemaining;

  @override
  Future<TicketsContent> fetchTickets() async {
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure('Gagal memuat tiket');
    }
    return demoTickets;
  }
}
