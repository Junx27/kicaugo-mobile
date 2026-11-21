import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/core/network/api_paths.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/api_home_data_source.dart';
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
    'fetchHomeContent memetakan payload menjadi entity yang sama dengan dummy',
    () async {
      adapter.body = jsonEncode(homeApiPayload());

      final content = await dataSource.fetchHomeContent();

      expectHomeContentEquals(content, expectedHomeContent);
      expect(adapter.recordedOptions!.path, ApiPaths.home);
      expect(
        adapter.recordedOptions!.headers['Authorization'],
        'Bearer jwt-token',
      );
    },
  );

  test('fetchHomeContent membuka envelope data dari backend', () async {
    adapter.body = jsonEncode(<String, dynamic>{
      'status': 200,
      'message': 'Home content loaded successfully',
      'data': homeApiPayload(),
    });

    final content = await dataSource.fetchHomeContent();

    expectHomeContentEquals(content, expectedHomeContent);
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

  test('payload dengan enum tidak dikenal ditolak', () async {
    final payload = homeApiPayload();
    final schedules = List<Map<String, dynamic>>.from(
      payload['schedules'] as List<Map<String, dynamic>>,
    );
    schedules[0] = <String, dynamic>{...schedules[0], 'status': 'unknown'};
    payload['schedules'] = schedules;
    adapter.body = jsonEncode(payload);

    await expectLater(
      dataSource.fetchHomeContent(),
      throwsA(isA<DataFailure>()),
    );
  });
}
