import 'package:rumahkicau_mobile/core/network/api_paths.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/contest_detail_data_source.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/fake_contest_detail_data_source.dart';
import 'package:rumahkicau_mobile/features/event/domain/entities/contest_detail.dart';
import 'package:rumahkicau_mobile/features/event/domain/repositories/contest_detail_repository.dart';

/// Path yang dipakai test datasource API detail lomba.
const String contestDetailPath = '${ApiPaths.contestDetail}/101';

/// Payload lengkap sesuai kontrak backend detail lomba.
Map<String, dynamic> contestDetailPayload() => <String, dynamic>{
  'id': 101,
  'title': 'Piala Raja Nusantara 2025',
  'subtitle': 'Batavia Bird Club & PBI Cabang Jakarta',
  'official_badge': 'Resmi PBI & BnR',
  'format_badge': '24G & 36G',
  'edition_label': 'Edisi Akbar Tahunan',
  'hero_image_url': 'https://example.com/contest-hero.jpg',
  'banner_image_url': 'https://example.com/contest-banner.jpg',
  'status': 'open',
  'distance': '5 km',
  'schedule_text': 'Minggu, 18 Mei 2025',
  'quota': <String, dynamic>{
    'total': 36,
    'remaining': 12,
    'label': 'Kuota Tersedia',
  },
  'schedule': <String, dynamic>{
    'date': 'Minggu, 18 Mei 2025',
    'time': '08:30 WIB',
    'gate_open': '07:00 WIB',
  },
  'location': <String, dynamic>{
    'name': 'Batavia Arena Gantangan',
    'address': 'Jakarta Barat',
    'distance': '5 km',
    'map_image_url': 'https://example.com/map.png',
    'latitude': -6.2,
    'longitude': 106.8,
    'parking': 'Luas',
  },
  'prize': <String, dynamic>{
    'total': 'Rp 50.000.000',
    'trophy': 'Trophy',
    'highlight': 'Juara umum',
  },
  'stats': <String, dynamic>{
    'format': <String, dynamic>{'label': 'Format', 'note': '24G'},
    'judging': <String, dynamic>{'label': 'Penjurian', 'note': '7 juri'},
    'facilities': <String, dynamic>{'label': 'Fasilitas', 'note': 'Lengkap'},
  },
  'ticket': <String, dynamic>{
    'starting_price': 'Rp 150.000',
    'unit': 'per gantangan',
    'cta': 'Beli Tiket',
  },
  'classes': <Object?>[
    <String, dynamic>{
      'id': 4,
      'name': 'Murai Batu Utama',
      'session': 'Sesi 04',
      'time': '09:00 WIB',
      'remaining_slots': 8,
      'price': 'Rp 250.000',
      'prize_highlight': 'Rp 10.000.000',
    },
  ],
  'rules': <Object?>[
    <String, dynamic>{
      'title': 'Aturan Sangkar',
      'description': 'Isi aturan',
      'severity': 'info',
    },
  ],
};

/// Payload dengan nilai kosong dan tipe tidak sesuai untuk menguji fallback.
Map<String, dynamic> contestDetailEdgePayload() {
  final json = contestDetailPayload();
  json['hero_image_url'] = '';
  json['banner_image_url'] = 7;
  json['quota'] = <String, dynamic>{
    'total': 36,
    'remaining': 12.5,
    'label': 42,
  };
  json['schedule'] = <Object?, String>{'lain': 'diabaikan'};

  final location = json['location'] as Map<String, dynamic>;
  location['latitude'] = 'bukan angka';
  location['longitude'] = 106;

  final stats = json['stats'] as Map<String, dynamic>;
  stats['judging'] = 'bukan objek';

  final classes = json['classes'] as List<Object?>;
  classes[0] = <String, dynamic>{
    'id': 5.5,
    'name': 7,
    'session': 'Sesi 02',
    'time': 8,
    'remaining_slots': '8',
    'price': 'Rp 150.000',
    'prize_highlight': 9,
  };

  final rules = json['rules'] as List<Object?>;
  rules[0] = <String, dynamic>{
    'title': 1,
    'description': 'Isi aturan',
    'severity': 2,
  };
  return json;
}

/// Sumber data palsu untuk menguji jalur gagal pada halaman detail.
class StubContestDetailDataSource implements ContestDetailDataSource {
  StubContestDetailDataSource({this.error, this.detail});

  final Object? error;
  final ContestDetail? detail;

  @override
  Future<ContestDetail> fetchContestDetail(int id) async {
    if (error != null) throw error!;
    return detail ?? FakeContestDetailDataSource.content;
  }
}

/// Repository palsu untuk test usecase dan cubit detail lomba.
class StubContestDetailRepository implements ContestDetailRepository {
  StubContestDetailRepository({this.error, this.detail});

  final Object? error;
  final ContestDetail? detail;
  int? lastId;

  @override
  Future<ContestDetail> fetchContestDetail(int id) async {
    lastId = id;
    if (error != null) throw error!;
    return detail ?? FakeContestDetailDataSource.content;
  }
}
