import 'dart:async';

import '../../domain/entities/ticket_history_content.dart';
import 'ticket_history_data_source.dart';

class FakeTicketHistoryDataSource implements TicketHistoryDataSource {
  const FakeTicketHistoryDataSource({
    this.delay = const Duration(milliseconds: 400),
  });

  final Duration delay;

  static const TicketHistoryContent content = TicketHistoryContent();

  @override
  Future<TicketHistoryContent> fetchTicketHistory() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return content;
  }
}
