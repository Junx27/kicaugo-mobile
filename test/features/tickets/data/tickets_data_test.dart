import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/features/tickets/data/datasources/fake_tickets_data_source.dart';

import '../support.dart';

void main() {
  test('sumber data demo mengembalikan konten tiket', () async {
    final content = await const FakeTicketsDataSource(
      delay: Duration.zero,
    ).fetchTickets();

    expect(content, demoTickets);
    expect(content.upcoming, hasLength(2));
    expect(content.history, hasLength(5));
    expect(content.cancelled, hasLength(1));
  });

  test('usecase meneruskan data dari repository', () async {
    final content = await instantTickets();

    expect(content.upcoming.first.seat.number, '#G-18');
    expect(content.cancelled.single.result, isNull);
  });

  test('data demo bebas nama organisasi nyata', () {
    final text = [
      for (final ticket in demoTickets.upcoming) ...[
        ...ticket.event.props,
        ...ticket.seat.props,
        ...ticket.bird.props,
      ],
      for (final ticket in [...demoTickets.history, ...demoTickets.cancelled])
        ...ticket.props,
      ...demoTickets.stats.podium.props,
      ...demoTickets.stats.ring.props,
    ].join(' ');

    for (final banned in ['PBI', 'BnR', 'Ronggolawe', 'Oriq']) {
      expect(text.contains(banned), isFalse, reason: banned);
    }
  });

  test('setiap entity mengekspos seluruh field lewat props', () {
    final upcoming = demoTickets.upcoming.first;
    final past = demoTickets.history.first;

    expect(demoTickets.props, hasLength(4));
    expect(upcoming.props, hasLength(6));
    expect(upcoming.event.props, hasLength(6));
    expect(upcoming.seat.props, hasLength(4));
    expect(upcoming.bird.props, hasLength(4));
    expect(past.props, hasLength(5));
    expect(demoTickets.stats.podium.props, hasLength(3));
    expect(upcoming.category, BirdCategory.muraiBatu);
  });
}
