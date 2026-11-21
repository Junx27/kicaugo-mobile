import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/logging/app_logger.dart';
import 'package:rumahkicau_mobile/core/network/api_logging_interceptor.dart';

import '../../support/fake_http.dart';

void main() {
  late FakeHttpAdapter adapter;
  late Dio dio;
  late List<String> lines;

  setUp(() {
    adapter = FakeHttpAdapter();
    dio = testDio(adapter);
    dio.interceptors.add(ApiLoggingInterceptor());
    lines = <String>[];
    AppLogger.enabled = true;
    AppLogger.setSink(lines.add);
  });

  tearDown(() => AppLogger.setSink(null));

  String output() => lines.join('\n');

  String lineContaining(String fragment) =>
      lines.firstWhere((line) => line.contains(fragment));

  test('mencatat method dan URL untuk GET tanpa payload', () async {
    await dio.get<String>('/home');

    expect(output(), contains('🌐 [API] REQUEST GET http://localhost/home'));
    expect(lines.any((line) => line.contains('PAYLOAD')), isFalse);
  });

  test('mencatat payload dengan kata sandi dan token di-mask', () async {
    await dio.post<String>(
      '/auth/login',
      data: <String, dynamic>{
        'email': 'user@kicaugo.id',
        'password': 'rahasia',
        'token': 'jwt-value',
      },
    );

    final payload = lineContaining('PAYLOAD');
    expect(payload, contains('user@kicaugo.id'));
    expect(payload, contains('***'));
    expect(payload, isNot(contains('rahasia')));
    expect(payload, isNot(contains('jwt-value')));
  });

  test('memask payload yang dikirim sebagai string JSON', () async {
    await dio.post<String>(
      '/auth/login',
      data: '{"password":"rahasia","email":"user@kicaugo.id"}',
    );

    final payload = lineContaining('PAYLOAD');
    expect(payload, contains('user@kicaugo.id'));
    expect(payload, isNot(contains('rahasia')));
  });

  test('memask kunci sensitif di dalam list bertingkat', () async {
    await dio.post<String>(
      '/test',
      data: <String, dynamic>{
        'items': <Object>[
          <String, dynamic>{'password': 'rahasia'},
          <String, dynamic>{'note': 'aman'},
        ],
      },
    );

    final payload = lineContaining('PAYLOAD');
    expect(payload, contains('***'));
    expect(payload, contains('aman'));
    expect(payload, isNot(contains('rahasia')));
  });

  test('memask header Authorization dan membiarkan header lain', () async {
    await dio.get<String>(
      '/home',
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer secret-token',
          'X-Request-Id': 'abc-123',
        },
      ),
    );

    final headers = lineContaining('HEADERS');
    expect(headers, isNot(contains('secret-token')));
    expect(headers, contains('abc-123'));
  });

  test('header yang tidak bisa di-encode memakai toString', () async {
    await dio.get<String>(
      '/home',
      options: Options(headers: <String, dynamic>{'X-Object': Object()}),
    );

    expect(lineContaining('HEADERS'), contains('Instance of'));
  });

  test('payload dicetak rapi setelah masking', () async {
    await dio.post<String>(
      '/auth/login',
      data: <String, dynamic>{
        'email': 'user@kicaugo.id',
        'password': 'rahasia',
      },
    );

    final payload = lineContaining('PAYLOAD');
    expect(payload, contains('{\n  "email": "user@kicaugo.id"'));
    expect(payload, contains('  "password": "***"'));
    expect(payload, isNot(contains('rahasia')));
  });

  test('mencatat status dan body response', () async {
    adapter.body = '{"status":"ok"}';

    await dio.get<String>('/home');

    expect(output(), contains('RESPONSE 200 GET http://localhost/home'));
    expect(lineContaining('RESPONSE'), contains('{\n  "status": "ok"'));
  });

  test('respons 4xx tetap dicatat tanpa melempar', () async {
    dio.options.validateStatus = (_) => true;
    adapter
      ..statusCode = 400
      ..body = '{"message":"Bad Request"}';

    await dio.get<String>('/home');

    expect(output(), contains('RESPONSE 400 GET http://localhost/home'));
    expect(lineContaining('RESPONSE'), contains('"message": "Bad Request"'));
  });

  test('mencatat status, pesan, dan body saat error', () async {
    adapter
      ..statusCode = 401
      ..body = '{"message":"Unauthorized"}';

    await expectLater(dio.get<String>('/home'), throwsA(isA<DioException>()));

    expect(output(), contains('ERROR 401 GET http://localhost/home'));
    expect(lineContaining('ERROR'), contains('  "message": "Unauthorized"'));
  });

  test('body error dicetak rapi dengan kunci sensitif ter-mask', () async {
    adapter
      ..statusCode = 401
      ..body = '{"message":"Unauthorized","token":"secret"}';

    await expectLater(dio.get<String>('/home'), throwsA(isA<DioException>()));

    final line = lineContaining('ERROR');
    expect(line, contains('  "message": "Unauthorized"'));
    expect(line, contains('  "token": "***"'));
    expect(line, isNot(contains('secret')));
  });

  test('memotong body yang terlalu panjang', () async {
    adapter.body = '{"data":"${'x' * 4100}"}';

    await dio.get<String>('/home');

    expect(lineContaining('RESPONSE'), contains('... (truncated)'));
  });

  test('memakai toString bila body tidak bisa di-encode', () async {
    await dio.post<String>('/test', data: Object());

    expect(lineContaining('PAYLOAD'), contains('Instance of'));
  });
}
