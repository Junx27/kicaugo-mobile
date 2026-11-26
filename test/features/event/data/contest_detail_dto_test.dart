import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/contest_detail_dto.dart';

import '../support/contest_detail_fixture.dart';

void main() {
  test('fromJson memetakan seluruh bagian detail lomba', () {
    final detail = ContestDetailDto.fromJson(contestDetailPayload());

    expect(detail.id, 101);
    expect(detail.header.heroImageUrl, 'https://example.com/contest-hero.jpg');
    expect(
      detail.header.bannerImageUrl,
      'https://example.com/contest-banner.jpg',
    );
    expect(detail.info.quota.remaining, 12);
    expect(detail.info.quota.label, 'Kuota Tersedia');
    expect(detail.info.schedule.date, 'Minggu, 18 Mei 2025');
    expect(detail.info.schedule.time, '08:30 WIB');
    expect(detail.info.schedule.gateOpen, '07:00 WIB');
    expect(detail.info.location.latitude, -6.2);
    expect(detail.info.location.longitude, 106.8);
    expect(detail.info.location.mapImageUrl, 'https://example.com/map.png');
    expect(detail.info.prize.total, 'Rp 50.000.000');
    expect(detail.info.stats.format.label, 'Format');
    expect(detail.info.stats.judging.note, '7 juri');
    expect(detail.info.stats.facilities.note, 'Lengkap');
    expect(detail.info.ticket.unit, 'per gantangan');
    expect(detail.info.ticket.cta, 'Beli Tiket');
    expect(detail.info.distance, '5 km');
    expect(detail.info.scheduleText, 'Minggu, 18 Mei 2025');
    expect(detail.classes.single.slotLabel, 'Sisa 8 Gantangan');
    expect(detail.rules.single.severity, 'info');
  });

  test(
    'fromJson memakai fallback untuk nilai kosong dan tipe tidak sesuai',
    () {
      final detail = ContestDetailDto.fromJson(contestDetailEdgePayload());

      expect(detail.header.heroImageUrl, isNull);
      expect(detail.header.bannerImageUrl, isNull);
      expect(detail.info.quota.remaining, 12);
      expect(detail.info.quota.label, isEmpty);
      expect(detail.info.schedule.date, isEmpty);
      expect(detail.info.location.latitude, isNull);
      expect(detail.info.location.longitude, 106);
      expect(detail.info.stats.judging.label, isEmpty);
      expect(detail.classes.single.id, 5);
      expect(detail.classes.single.name, isEmpty);
      expect(detail.classes.single.time, isEmpty);
      expect(detail.classes.single.remainingSlots, isNull);
      expect(detail.rules.single.title, isEmpty);
      expect(detail.rules.single.severity, isEmpty);
    },
  );
}
