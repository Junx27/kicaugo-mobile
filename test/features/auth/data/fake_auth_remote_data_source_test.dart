import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/fake_auth_remote_data_source.dart';

Matcher _failsWith(String message) => throwsA(
  isA<AuthFailure>().having((failure) => failure.message, 'message', message),
);

void main() {
  late FakeAuthRemoteDataSource dataSource;

  setUp(() => dataSource = FakeAuthRemoteDataSource(delay: Duration.zero));

  group('login', () {
    test('akun demo test@gmail.com / test123@ berhasil masuk', () async {
      final user = await dataSource.login(
        identifier: ' Test@Gmail.com ',
        password: 'test123@',
      );

      expect(user.name, 'Kicau Mania');
      expect(user.identifier, 'Test@Gmail.com');
    });

    test('sandi salah ditolak', () async {
      await expectLater(
        dataSource.login(identifier: 'test@gmail.com', password: 'salah123'),
        _failsWith(AppConstants.loginFailure),
      );
    });

    test('akun yang belum terdaftar ditolak', () async {
      await expectLater(
        dataSource.login(identifier: 'lain@gmail.com', password: 'test123@'),
        _failsWith(AppConstants.loginFailure),
      );
    });
  });

  group('register', () {
    test('akun baru bisa langsung dipakai masuk', () async {
      final user = await dataSource.register(
        name: '  Sari  ',
        identifier: '+62 812-3456-7890',
        password: 'rahasia123',
      );
      final loggedIn = await dataSource.login(
        identifier: '081234567890',
        password: 'rahasia123',
      );

      expect(user.name, 'Sari');
      expect(loggedIn.name, 'Sari');
    });

    test('identifier yang sudah terdaftar ditolak', () async {
      await expectLater(
        dataSource.register(
          name: 'Sari',
          identifier: 'TEST@gmail.com',
          password: 'rahasia123',
        ),
        _failsWith(AppConstants.accountExists),
      );
    });

    test('data tidak valid ditolak', () async {
      await expectLater(
        dataSource.register(
          name: 'Al',
          identifier: 'sari@kicaugo.id',
          password: 'rahasia123',
        ),
        _failsWith(AppConstants.registerFailure),
      );
      await expectLater(
        dataSource.register(
          name: 'Sari',
          identifier: 'sari',
          password: 'rahasia123',
        ),
        _failsWith(AppConstants.registerFailure),
      );
    });

    test('akun baru tidak bocor ke instance lain', () async {
      await dataSource.register(
        name: 'Sari',
        identifier: 'sari@kicaugo.id',
        password: 'rahasia123',
      );
      final other = FakeAuthRemoteDataSource(delay: Duration.zero);

      await expectLater(
        other.login(identifier: 'sari@kicaugo.id', password: 'rahasia123'),
        _failsWith(AppConstants.loginFailure),
      );
    });
  });

  test('logout selesai tanpa error', () async {
    await expectLater(dataSource.logout(), completes);
  });
}
