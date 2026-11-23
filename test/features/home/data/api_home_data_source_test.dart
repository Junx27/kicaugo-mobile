import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/core/network/api_paths.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/api_home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';

import '../../../support/fake_http.dart';
import 'home_api_fixture.dart';

/// [FakeHttpAdapter] mencocokkan path lengkap termasuk query string.
const String profilePath =
    '${ApiPaths.homeProfile}?radius_km=1&category_id=1&limit=5';
const String featuredTitle = 'Lomba Unggulan dari API';

void main() {
  late FakeHttpAdapter adapter;
  late ApiHomeDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      bodyByPath: <String, String>{
        profilePath: jsonEncode(homeProfilePayload()),
        ApiPaths.homeFeatured: jsonEncode(
          homeFeaturedPayload(title: featuredTitle),
        ),
        ApiPaths.homeBirdCategories: jsonEncode(homeBirdCategoriesPayload()),
      },
    );
    dataSource = ApiHomeDataSource(
      ApiClient(testDio(adapter), FakeTokenProvider('jwt-token')),
    );
  });

  test(
    'fetchHomeContent memetakan profil, featured, dan kategori backend',
    () async {
      final content = await dataSource.fetchHomeContent();

      expect(content.profile.greeting, 'Selamat siang');
      expect(content.profile.name, 'Kicau Mania');
      expect(content.profile.avatarUrl, 'https://example.com/avatar.png');
      expect(content.profile.liveCount, 7);
      expect(content.featured.title, featuredTitle);
      expect(
        content.featured.schedule,
        'Minggu, 6 Des • Batavia Arena, Jaksel',
      );
      expect(content.featured.attendees.initials, <String>['MK', 'BN']);
      expect(content.featured.attendees.others, 48);
      expect(content.categories, HomeDemoDataSource.categories);
      expect(content.upcoming, HomeDemoDataSource.content.upcoming);
      expect(content.stats, HomeDemoDataSource.content.stats);
      expect(content.activeTicket, HomeDemoDataSource.content.activeTicket);
      expect(content.schedules, HomeDemoDataSource.content.schedules);
    },
  );

  test('fetchHomeContent membuka envelope data dari backend', () async {
    adapter.bodyByPath = <String, String>{
      profilePath: jsonEncode(<String, dynamic>{
        'status': 200,
        'message': 'Home profile loaded',
        'data': homeProfilePayload(),
      }),
      ApiPaths.homeFeatured: jsonEncode(<String, dynamic>{
        'status': 200,
        'message': 'Home featured loaded',
        'data': homeFeaturedPayload(title: featuredTitle),
      }),
      ApiPaths.homeBirdCategories: jsonEncode(homeBirdCategoriesPayload()),
    };

    final content = await dataSource.fetchHomeContent();

    expect(content.profile.name, 'Kicau Mania');
    expect(content.featured.title, featuredTitle);
    expect(content.categories, HomeDemoDataSource.categories);
  });

  test('meminta kategori terakhir dengan header Bearer', () async {
    await dataSource.fetchHomeContent();

    expect(adapter.recordedOptions?.path, ApiPaths.homeBirdCategories);
    expect(
      adapter.recordedOptions?.headers['Authorization'],
      'Bearer jwt-token',
    );
  });

  test('kesalahan 500 diteruskan sebagai DataFailure', () async {
    adapter
      ..bodyByPath = null
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

  test('endpoint tidak tersedia diteruskan tanpa fallback demo', () async {
    adapter
      ..bodyByPath = null
      ..statusCode = 404
      ..body = '404 page not found';

    await expectLater(
      dataSource.fetchHomeContent(),
      throwsA(isA<DataFailure>()),
    );
  });

  test('kesalahan tak dikenal diteruskan tanpa fallback demo', () async {
    final source = ApiHomeDataSource(
      ApiClient(testDio(adapter), ThrowingTokenProvider()),
    );

    await expectLater(
      source.fetchHomeContent(),
      throwsA(
        isA<DataFailure>().having(
          (failure) => failure.message,
          'message',
          AppConstants.apiUnexpected,
        ),
      ),
    );
  });

  test('kegagalan koneksi diteruskan ke pemanggil', () async {
    adapter.exception = DioException(
      requestOptions: RequestOptions(path: profilePath),
      type: DioExceptionType.connectionError,
    );

    await expectLater(
      dataSource.fetchHomeContent(),
      throwsA(
        isA<DataFailure>().having(
          (failure) => failure.message,
          'message',
          AppConstants.apiConnection,
        ),
      ),
    );
  });

  test('payload tidak valid ditolak', () async {
    adapter
      ..bodyByPath = null
      ..body = jsonEncode(<String, dynamic>{'foo': 'bar'});

    await expectLater(
      dataSource.fetchHomeContent(),
      throwsA(isA<DataFailure>()),
    );
  });
}
