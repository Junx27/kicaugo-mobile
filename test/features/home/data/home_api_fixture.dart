import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_content.dart';

/// Payload `/api/v1/home/featured` sesuai kontrak backend.
Map<String, dynamic> homeFeaturedPayload({
  String title = 'Piala Raja Nusantara 2026',
}) => <String, dynamic>{
  'title': title,
  'schedule': 'Minggu, 6 Des • Batavia Arena, Jaksel',
  'distance': '3.2 KM',
  'prize': 'Rp 50 Jt',
  'slots': '12 Gantangan',
  'attendees': <String, dynamic>{
    'initials': <String>['MK', 'BN'],
    'others': 48,
  },
};

/// Payload `/api/v1/home/profile` sesuai kontrak baru backend (4 field).
Map<String, dynamic> homeProfilePayload() => <String, dynamic>{
  'name': 'Kicau Mania',
  'avatar': 'https://example.com/avatar.png',
  'message': 'Selamat siang',
  'live_count': 7,
};

/// Payload profil tanpa avatar untuk menguji field nullable.
Map<String, dynamic> homeProfilePayloadWithoutAvatar() => <String, dynamic>{
  ...homeProfilePayload(),
  'avatar': null,
};

/// Hasil mapping yang diharapkan: sama persis dengan data dummy Beranda.
HomeContent get expectedHomeContent => HomeDemoDataSource.content;

/// Membandingkan tiap field karena record [Attendees] memakai List (identity ==).
void expectHomeContentEquals(HomeContent actual, HomeContent expected) {
  final featured = actual.featured;
  final expectedFeatured = expected.featured;

  expect(actual.profile, expected.profile);
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
