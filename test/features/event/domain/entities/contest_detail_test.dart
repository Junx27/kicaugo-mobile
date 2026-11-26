import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/event/domain/entities/contest_detail.dart';

void main() {
  test('ContestClass menyimpan seluruh field dan label kuota', () {
    const limited = ContestClass(
      id: 1,
      name: 'Murai Batu',
      session: 'Sesi 01',
      time: '08:00 WIB',
      remainingSlots: 4,
      price: 'Rp 100.000',
      prizeHighlight: 'Rp 10.000.000',
    );
    expect(limited.props, <Object?>[
      limited.id,
      limited.name,
      limited.session,
      limited.time,
      limited.remainingSlots,
      limited.price,
      limited.prizeHighlight,
    ]);
    expect(limited.slotLabel, 'Sisa 4 Gantangan');

    const unlimited = ContestClass(
      id: 3,
      name: 'Kacer',
      session: 'Sesi 02',
      time: '09:00 WIB',
      price: 'Rp 150.000',
      prizeHighlight: 'Rp 5.000.000',
    );
    expect(unlimited.slotLabel, 'Tersedia');
  });

  test('ContestRule dan ContestQuota menyimpan seluruh field', () {
    const rule = ContestRule(
      title: 'Aturan',
      description: 'Isi aturan',
      severity: 'info',
    );
    expect(rule.props, <Object?>[rule.title, rule.description, rule.severity]);

    const quota = ContestQuota(total: 36, remaining: 12, label: 'Kuota');
    expect(quota.props, <Object?>[quota.total, quota.remaining, quota.label]);
  });

  test('ContestSchedule dan ContestLocation menyimpan seluruh field', () {
    const schedule = ContestSchedule(
      date: 'Minggu',
      time: '08:00 WIB',
      gateOpen: '07:00 WIB',
    );
    expect(schedule.props, <Object?>[
      schedule.date,
      schedule.time,
      schedule.gateOpen,
    ]);

    const location = ContestLocation(
      name: 'Arena',
      address: 'Jakarta',
      distance: '5 km',
      mapImageUrl: 'https://example.com/map.png',
      latitude: -6.2,
      longitude: 106.8,
      parking: 'Luas',
    );
    expect(location.props, <Object?>[
      location.name,
      location.address,
      location.distance,
      location.mapImageUrl,
      location.latitude,
      location.longitude,
      location.parking,
    ]);
  });

  test('ContestPrize, ContestStatItem, dan ContestStats menyimpan field', () {
    const prize = ContestPrize(
      total: 'Rp 50.000.000',
      trophy: 'Trophy',
      highlight: 'Juara',
    );
    expect(prize.props, <Object?>[prize.total, prize.trophy, prize.highlight]);

    const stat = ContestStatItem(label: 'Format', note: '24G');
    expect(stat.props, <Object?>[stat.label, stat.note]);

    const stats = ContestStats(format: stat, judging: stat, facilities: stat);
    expect(stats.props, <Object?>[stat, stat, stat]);
  });

  test('ContestTicket, header, info, dan detail menyimpan field', () {
    const ticket = ContestTicket(
      startingPrice: 'Rp 150.000',
      unit: 'per gantangan',
      cta: 'Beli Tiket',
    );
    expect(ticket.props, <Object?>[
      ticket.startingPrice,
      ticket.unit,
      ticket.cta,
    ]);

    const header = ContestDetailHeader(
      title: 'Lomba',
      subtitle: 'Subtitle',
      officialBadge: 'Resmi',
      formatBadge: '24G',
      editionLabel: 'Edisi',
      heroImageUrl: 'https://example.com/hero.jpg',
      bannerImageUrl: 'https://example.com/banner.jpg',
      status: 'open',
    );
    expect(header.props, <Object?>[
      header.title,
      header.subtitle,
      header.officialBadge,
      header.formatBadge,
      header.editionLabel,
      header.heroImageUrl,
      header.bannerImageUrl,
      header.status,
    ]);

    const quota = ContestQuota(total: 36, remaining: 12, label: 'Kuota');
    const schedule = ContestSchedule(
      date: 'Minggu',
      time: '08:00 WIB',
      gateOpen: '07:00 WIB',
    );
    const location = ContestLocation(
      name: 'Arena',
      address: 'Jakarta',
      distance: '5 km',
      parking: 'Luas',
    );
    const prize = ContestPrize(
      total: 'Rp 50.000.000',
      trophy: 'Trophy',
      highlight: 'Juara',
    );
    const stat = ContestStatItem(label: 'Format', note: '24G');
    const stats = ContestStats(format: stat, judging: stat, facilities: stat);
    const info = ContestDetailInfo(
      quota: quota,
      schedule: schedule,
      location: location,
      prize: prize,
      stats: stats,
      ticket: ticket,
      distance: '5 km',
      scheduleText: 'Minggu, 18 Mei',
    );
    expect(info.props, <Object?>[
      info.quota,
      info.schedule,
      info.location,
      info.prize,
      info.stats,
      info.ticket,
      info.distance,
      info.scheduleText,
    ]);

    const contestClass = ContestClass(
      id: 1,
      name: 'Murai',
      session: 'Sesi 01',
      time: '08:00',
      price: 'Rp 100.000',
      prizeHighlight: 'Rp 10.000.000',
    );
    const rule = ContestRule(
      title: 'Aturan',
      description: 'Isi aturan',
      severity: 'info',
    );
    const detail = ContestDetail(
      id: 101,
      header: header,
      info: info,
      classes: <ContestClass>[contestClass],
      rules: <ContestRule>[rule],
    );
    expect(detail.props, <Object?>[
      detail.id,
      detail.header,
      detail.info,
      detail.classes,
      detail.rules,
    ]);
  });
}
