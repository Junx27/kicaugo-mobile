import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/tickets/data/datasources/fake_ticket_history_data_source.dart';
import 'package:rumahkicau_mobile/features/tickets/data/repositories/ticket_history_repository_impl.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/ticket_history_content.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/usecases/get_ticket_history_content.dart';

import '../ticket_history_fakes.dart';

void main() {
  test('fake data source mengembalikan konten', () async {
    const dataSource = FakeTicketHistoryDataSource(delay: Duration.zero);
    final content = await dataSource.fetchTicketHistory();
    expect(content, same(FakeTicketHistoryDataSource.content));
    expect(content.loaded, isTrue);
  });

  test('fake data source menunggu delay', () async {
    const dataSource = FakeTicketHistoryDataSource(
      delay: Duration(milliseconds: 1),
    );
    final content = await dataSource.fetchTicketHistory();
    expect(content.loaded, isTrue);
  });

  test('repository meneruskan konten', () async {
    const repository = TicketHistoryRepositoryImpl(
      FakeTicketHistoryDataSource(delay: Duration.zero),
    );
    final content = await repository.fetchTicketHistory();
    expect(content, same(FakeTicketHistoryDataSource.content));
  });

  test('usecase memanggil repository', () async {
    final repository = FlakyTicketHistoryRepository(failuresRemaining: 0);
    final content = await GetTicketHistoryContent(repository)();
    expect(content, demoTicketHistory);
  });

  test('entity equality', () {
    const a = TicketHistoryContent();
    const b = TicketHistoryContent();
    expect(a, b);
    expect(const TicketHistoryContent(loaded: false), isNot(a));
  });
}
