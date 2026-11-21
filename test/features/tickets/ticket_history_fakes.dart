import 'dart:async';

import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/tickets/data/datasources/fake_ticket_history_data_source.dart';
import 'package:rumahkicau_mobile/features/tickets/data/repositories/ticket_history_repository_impl.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/ticket_history_content.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/repositories/ticket_history_repository.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/usecases/get_ticket_history_content.dart';

/// Data demo yang dipakai test.
const TicketHistoryContent demoTicketHistory =
    FakeTicketHistoryDataSource.content;

/// Usecase tanpa jeda.
const GetTicketHistoryContent instantTicketHistory = GetTicketHistoryContent(
  TicketHistoryRepositoryImpl(
    FakeTicketHistoryDataSource(delay: Duration.zero),
  ),
);

/// Repository yang gagal sejumlah [failuresRemaining] kali.
class FlakyTicketHistoryRepository implements TicketHistoryRepository {
  FlakyTicketHistoryRepository({this.failuresRemaining = 1});

  int failuresRemaining;

  @override
  Future<TicketHistoryContent> fetchTicketHistory() async {
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure('Gagal memuat riwayat tiket');
    }
    return demoTicketHistory;
  }
}

/// Repository yang menunggu [completer] untuk menguji loading.
class PendingTicketHistoryRepository implements TicketHistoryRepository {
  PendingTicketHistoryRepository(this.completer);

  final Completer<TicketHistoryContent> completer;

  @override
  Future<TicketHistoryContent> fetchTicketHistory() => completer.future;
}
