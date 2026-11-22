import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/api_home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';

import '../../../support/fake_http.dart';
import 'home_api_fixture.dart';

void main() {
  late FakeHttpAdapter adapter;
  late ApiHomeDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter();
    dataSource = ApiHomeDataSource(
      ApiClient(testDio(adapter), FakeTokenProvider('jwt-token')),
    );
  });

  test(
    'fetchHomeContent memetakan profil backend ke summary, bagian lain tetap demo',
    () async {
      adapter.body = jsonEncode(homeProfilePayload());

      final content = await dataSource.fetchHomeContent();

      expect(content.summary.greeting, 'Selamat pagi');
      expect(content.summary.fullName, 'Budi Santoso');
      expect(content.summary.avatarUrl, 'https://example.com/avatar.png');
      expect(content.summary.location, 'Bandung');
      expect(content.summary.liveCount, 7);
      expect(content.summary.searchRadiusKM, 10);
      expect(content.summary.isComplete, isTrue);
      expect(content.summary.favoriteCategories, hasLength(1));
      expect(content.featured, HomeDemoDataSource.content.featured);
      expect(content.upcoming, HomeDemoDataSource.content.upcoming);
      expect(content.stats, HomeDemoDataSource.content.stats);
      expect(content.activeTicket, HomeDemoDataSource.content.activeTicket);
      expect(content.schedules, HomeDemoDataSource.content.schedules);
    },
  );

  test('fetchHomeContent membuka envelope data dari backend', () async {
    adapter.body = jsonEncode(<String, dynamic>{
      'status': 200,
      'message': 'Home profile loaded',
      'data': homeProfilePayload(),
    });

    final content = await dataSource.fetchHomeContent();

    expect(content.summary.fullName, 'Budi Santoso');
    expect(content.summary.location, 'Bandung');
  });

  test('kesalahan 500 diteruskan sebagai DataFailure', () async {
    adapter
      ..statusCode = 500
      ..body = jsonEncode(<String, dynamic>{
        'error': <String, dynamic>{'message': 'Gagal memuat'},
      });

    await expectLater(
      dataSource.fetchHomeContent(),
      throwsA(
        isA<DataFailure>().having(
          (failure) => failure.message,
          'message',
          'Gagal memuat',
        ),
      ),
    );
  });

  test('endpoint tidak tersedia kembali ke data dummy', () async {
    adapter.statusCode = 404;
    adapter.body = '404 page not found';

    final content = await dataSource.fetchHomeContent();

    expect(content, HomeDemoDataSource.content);
  });

  test('payload tidak valid ditolak', () async {
    adapter.body = jsonEncode(<String, dynamic>{'foo': 'bar'});

    await expectLater(
      dataSource.fetchHomeContent(),
      throwsA(isA<DataFailure>()),
    );
  });
}
