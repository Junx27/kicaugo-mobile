import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/core/network/api_paths.dart';
import '../../support/fake_http.dart';

void main() {
  late FakeHttpAdapter adapter;
  late FakeTokenProvider tokens;
  late ApiClient client;

  setUp(() {
    adapter = FakeHttpAdapter();
    tokens = FakeTokenProvider('jwt-token');
    client = ApiClient(testDio(adapter), tokens);
  });

  test('getJson menyertakan token Bearer', () async {
    adapter.body = '{"status":"ok"}';

    final json = await client.getJson(ApiPaths.home);
    final options = adapter.recordedOptions!;

    expect(json, <String, dynamic>{'status': 'ok'});
    expect(options.method, 'GET');
    expect(options.path, ApiPaths.home);
    expect(options.headers['Authorization'], 'Bearer jwt-token');
  });

  test('getJson tanpa token tidak menyertakan header otorisasi', () async {
    tokens.token = null;

    await client.getJson(ApiPaths.home);

    expect(
      adapter.recordedOptions!.headers.containsKey('Authorization'),
      isFalse,
    );
  });

  test(
    'getJson dengan token kosong tidak menyertakan header otorisasi',
    () async {
      tokens.token = '';

      await client.getJson(ApiPaths.home);

      expect(
        adapter.recordedOptions!.headers.containsKey('Authorization'),
        isFalse,
      );
    },
  );

  test('postJson mengirim body dan mengurai respons', () async {
    adapter.body = '{"token":"jwt"}';

    final json = await client.postJson(
      ApiPaths.login,
      body: <String, dynamic>{'identifier': 'test@gmail.com'},
    );

    expect(json, <String, dynamic>{'token': 'jwt'});
    expect(adapter.recordedOptions!.method, 'POST');
    expect(recordedBody(adapter), <String, dynamic>{
      'identifier': 'test@gmail.com',
    });
  });

  test('getJson membuka envelope data dari backend', () async {
    adapter.body =
        '{"status":200,"message":"OK","data":{"summary":{"liveCount":2}}}';

    final json = await client.getJson(ApiPaths.home);

    expect(json, <String, dynamic>{
      'summary': <String, dynamic>{'liveCount': 2},
    });
  });

  test('postJson juga membuka envelope data', () async {
    adapter.body =
        '{"status":200,"message":"OK","data":{"token":"jwt-from-envelope"}}';

    final json = await client.postJson(ApiPaths.login);

    expect(json, <String, dynamic>{'token': 'jwt-from-envelope'});
  });

  test('decodeEnvelope mempertahankan response datar dan data non-map', () {
    expect(decodeEnvelope(<String, dynamic>{'token': 'jwt'}), <String, dynamic>{
      'token': 'jwt',
    });
    expect(
      decodeEnvelope(<String, dynamic>{'data': <dynamic>[]}),
      <String, dynamic>{'data': <dynamic>[]},
    );
  });

  test('postEmpty menyelesaikan request tanpa body', () async {
    adapter
      ..statusCode = 204
      ..body = '';

    await expectLater(client.postEmpty(ApiPaths.logout), completes);
    expect(adapter.recordedOptions!.method, 'POST');
  });

  test('menerjemahkan DioException menjadi Failure', () async {
    final options = RequestOptions(path: ApiPaths.home);
    adapter.exception = DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: options,
        statusCode: 401,
        data: <String, dynamic>{
          'error': <String, dynamic>{'message': 'Token tidak valid'},
        },
      ),
    );

    await expectLater(
      client.getJson(ApiPaths.home),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.message,
          'message',
          'Token tidak valid',
        ),
      ),
    );
  });

  test('menerjemahkan kegagalan pembaca token menjadi DataFailure', () async {
    final broken = ApiClient(testDio(adapter), ThrowingTokenProvider());

    await expectLater(
      broken.getJson(ApiPaths.home),
      throwsA(
        isA<DataFailure>().having(
          (failure) => failure.message,
          'message',
          AppConstants.apiUnexpected,
        ),
      ),
    );
  });

  test('kesalahan Dio tanpa status dipetakan sebagai koneksi', () async {
    adapter.exception = StateError('boom');

    await expectLater(
      client.getJson(ApiPaths.home),
      throwsA(
        isA<DataFailure>().having(
          (failure) => failure.message,
          'message',
          AppConstants.apiConnection,
        ),
      ),
    );
  });

  test('decodeJson menolak bentuk bukan map', () {
    expect(() => decodeJson('teks'), throwsA(isA<DataFailure>()));
    expect(decodeJson(<dynamic, dynamic>{'a': 1}), <String, dynamic>{'a': 1});
  });
}
