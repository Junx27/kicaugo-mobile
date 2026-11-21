import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/core/entities/ticket_status.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/fake_home_data_source.dart';

void main() {
  test('mengembalikan konten demo Beranda', () async {
    final content = await const FakeHomeDataSource(
      delay: Duration.zero,
    ).fetchHomeContent();

    expect(content, FakeHomeDataSource.content);
    expect(content.summary.activeTicketCount, 2);
    expect(content.featured.attendees.others, 48);
    expect(content.upcoming.remainingTickets, 3);
  });

  test('jadwal demo mencakup setiap status dan kosong untuk Lovebird', () {
    final schedules = FakeHomeDataSource.content.schedules;

    expect(
      schedules.map((item) => item.status).toSet(),
      TicketStatus.values.toSet(),
    );
    expect(
      schedules.where((item) => item.category == BirdCategory.lovebird),
      isEmpty,
    );
  });
}
