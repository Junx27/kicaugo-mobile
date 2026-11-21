import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/fake_home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_content.dart';

/// Payload `/api/v1/home` sesuai seed backend dan kontrak OpenAPI.
Map<String, dynamic> homeApiPayload() => <String, dynamic>{
  'summary': <String, dynamic>{
    'location': 'Jakarta Selatan',
    'liveCount': 14,
    'activeTicketCount': 2,
  },
  'featured': <String, dynamic>{
    'title': 'Piala Raja Nusantara 2026',
    'schedule': 'Minggu, 6 Des • Batavia Arena, Jaksel',
    'distance': '3.2 KM',
    'prize': 'Rp 50 Jt',
    'slots': '12 Gantangan',
    'attendees': <String, dynamic>{
      'initials': <String>['MK', 'BN'],
      'others': 48,
    },
  },
  'upcoming': <String, dynamic>{
    'type': 'Latber Presisi',
    'title': 'Latber Presisi Kacer',
    'time': 'Besok, 14:00 WIB',
    'price': 'Rp 75.000',
    'remainingTickets': 3,
  },
  'stats': <String, dynamic>{
    'badge': '100% Resmi',
    'headline': '520+ Gantangan',
    'note': 'Terverifikasi panitia & EO resmi.',
    'securityNote': '98% Transaksi Tiket Instan & Aman',
  },
  'activeTicket': <String, dynamic>{
    'event': 'Grand Prix Murai Batu VIP #18',
    'schedule': 'Sabtu, 12 Des • Masterpiece Arena',
    'number': '#G-18',
    'session': 'Sesi A - 16G',
  },
  'schedules': <Map<String, dynamic>>[
    <String, dynamic>{
      'title': 'Latpres Exclusive Cucak Ijo',
      'venue': 'Arena Master Cilandak, Jaksel',
      'date': 'Selasa, 24 Nov',
      'price': 'Rp 100rb',
      'status': 'available',
      'category': 'cucakHijau',
    },
    <String, dynamic>{
      'title': 'Festival Kicau Batavia',
      'venue': 'Gantangan Taman Mini, Jaktim',
      'date': 'Kamis, 26 Nov',
      'price': 'Rp 150rb',
      'status': 'almostGone',
      'category': 'muraiBatu',
    },
    <String, dynamic>{
      'title': 'Latber Kacer Mingguan',
      'venue': 'Lapangan Kicau Pesanggrahan, Jaksel',
      'date': 'Sabtu, 28 Nov',
      'price': 'Rp 60rb',
      'status': 'soldOut',
      'category': 'kacer',
    },
    <String, dynamic>{
      'title': 'Kenari Cup Kemang',
      'venue': 'Kemang Bird Park, Jaksel',
      'date': 'Minggu, 29 Nov',
      'price': 'Rp 85rb',
      'status': 'waiting',
      'category': 'kenari',
    },
  ],
};

/// Hasil mapping yang diharapkan: sama persis dengan data dummy Beranda.
HomeContent get expectedHomeContent => FakeHomeDataSource.content;

/// Membandingkan tiap field karena record [Attendees] memakai List (identity ==).
void expectHomeContentEquals(HomeContent actual, HomeContent expected) {
  final featured = actual.featured;
  final expectedFeatured = expected.featured;

  expect(actual.summary, expected.summary);
  expect(actual.upcoming, expected.upcoming);
  expect(actual.stats, expected.stats);
  expect(actual.activeTicket, expected.activeTicket);
  expect(actual.schedules, equals(expected.schedules));
  expect(featured.title, expectedFeatured.title);
  expect(featured.schedule, expectedFeatured.schedule);
  expect(featured.distance, expectedFeatured.distance);
  expect(featured.prize, expectedFeatured.prize);
  expect(featured.slots, expectedFeatured.slots);
  expect(
    featured.attendees.initials,
    equals(expectedFeatured.attendees.initials),
  );
  expect(featured.attendees.others, expectedFeatured.attendees.others);
}
