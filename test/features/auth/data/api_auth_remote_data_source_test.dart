import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/core/network/api_paths.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/api_auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/domain/entities/user.dart';
import '../../../support/fake_http.dart';

void main() {
  late FakeHttpAdapter adapter;
  late ApiAuthRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter();
    dataSource = ApiAuthRemoteDataSource(
      ApiClient(testDio(adapter), FakeTokenProvider(null)),
    );
  });

  void setAuthResponse() {
    adapter.body = jsonEncode(<String, dynamic>{
      'user': <String, dynamic>{
        'name': 'Kicau Mania',
        'identifier': 'test@gmail.com',
      },
      'token': 'jwt-token',
    });
  }

  test('login mengirim kredensial dan mengembalikan user bertoken', () async {
    setAuthResponse();

    final user = await dataSource.login(
      identifier: 'test@gmail.com',
      password: 'test123@',
    );

    expect(
      user,
      const User(
        name: 'Kicau Mania',
        identifier: 'test@gmail.com',
        token: 'jwt-token',
      ),
    );
    expect(adapter.recordedOptions!.path, ApiPaths.login);
    expect(recordedBody(adapter), <String, dynamic>{
      'identifier': 'test@gmail.com',
      'password': 'test123@',
    });
  });

  test('login menerima envelope standar backend', () async {
    adapter.body = jsonEncode(<String, dynamic>{
      'status': 200,
      'message': 'Login successful',
      'data': <String, dynamic>{
        'user': <String, dynamic>{
          'name': 'string',
          'identifier': 'user@example.com',
        },
        'token': 'jwt-token',
      },
    });

    final user = await dataSource.login(
      identifier: 'user@example.com',
      password: 'stringst',
    );

    expect(
      user,
      const User(
        name: 'string',
        identifier: 'user@example.com',
        token: 'jwt-token',
      ),
    );
  });

  test('register mengirim nama, identifier, dan password', () async {
    setAuthResponse();

    final user = await dataSource.register(
      name: 'Kicau Mania',
      identifier: 'test@gmail.com',
      password: 'test123@',
    );

    expect(user.token, 'jwt-token');
    expect(adapter.recordedOptions!.path, ApiPaths.register);
    expect(recordedBody(adapter), <String, dynamic>{
      'name': 'Kicau Mania',
      'identifier': 'test@gmail.com',
      'password': 'test123@',
    });
  });

  test('logout memanggil endpoint logout', () async {
    adapter
      ..statusCode = 204
      ..body = '';

    await dataSource.logout();

    expect(adapter.recordedOptions!.path, ApiPaths.logout);
  });

  test('kesalahan 401 diteruskan sebagai AuthFailure', () async {
    adapter
      ..statusCode = 401
      ..body = jsonEncode(<String, dynamic>{
        'error': <String, dynamic>{'message': 'Kredensial salah'},
      });

    await expectLater(
      dataSource.login(identifier: 'test@gmail.com', password: 'salah'),
      throwsA(isA<AuthFailure>()),
    );
  });

  test('respons tanpa token ditolak', () async {
    adapter.body = jsonEncode(<String, dynamic>{
      'user': <String, dynamic>{
        'name': 'Kicau Mania',
        'identifier': 'test@gmail.com',
      },
    });

    await expectLater(
      dataSource.login(identifier: 'test@gmail.com', password: 'test123@'),
      throwsA(isA<DataFailure>()),
    );
  });
}
