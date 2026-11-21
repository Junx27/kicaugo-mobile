import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rumahkicau_mobile/features/auth/domain/entities/user.dart';

class _RecordingAuthDataSource implements AuthRemoteDataSource {
  final List<String> calls = <String>[];
  bool fail = false;

  Future<User> _respond(String call, String name, String identifier) async {
    calls.add(call);
    if (fail) {
      throw const AuthFailure('Gagal');
    }
    return User(name: name, identifier: identifier);
  }

  @override
  Future<User> login({required String identifier, required String password}) =>
      _respond('login:$identifier:$password', 'Budi', identifier);

  @override
  Future<User> register({
    required String name,
    required String identifier,
    required String password,
  }) => _respond('register:$name:$identifier:$password', name, identifier);

  @override
  Future<void> logout() async => calls.add('logout');
}

void main() {
  late _RecordingAuthDataSource dataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = _RecordingAuthDataSource();
    repository = AuthRepositoryImpl(dataSource);
  });

  test('login meneruskan kredensial ke sumber data', () async {
    final user = await repository.login(
      identifier: 'demo@kicaugo.id',
      password: 'password123',
    );

    expect(dataSource.calls, ['login:demo@kicaugo.id:password123']);
    expect(user.identifier, 'demo@kicaugo.id');
  });

  test('register meneruskan data akun ke sumber data', () async {
    final user = await repository.register(
      name: 'Sari',
      identifier: '08123456789',
      password: 'password123',
    );

    expect(dataSource.calls, ['register:Sari:08123456789:password123']);
    expect(user.name, 'Sari');
  });

  test('kegagalan sumber data diteruskan apa adanya', () async {
    dataSource.fail = true;

    await expectLater(
      repository.login(identifier: 'demo@kicaugo.id', password: 'password123'),
      throwsA(isA<AuthFailure>()),
    );
  });

  test('logout diteruskan ke sumber data', () async {
    await repository.logout();

    expect(dataSource.calls, ['logout']);
  });
}
