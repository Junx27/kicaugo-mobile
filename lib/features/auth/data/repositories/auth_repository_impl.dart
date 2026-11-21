import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementasi [AuthRepository] yang meneruskan ke sumber data.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<User> login({required String identifier, required String password}) {
    return _remoteDataSource.login(identifier: identifier, password: password);
  }

  @override
  Future<User> register({
    required String name,
    required String identifier,
    required String password,
  }) {
    return _remoteDataSource.register(
      name: name,
      identifier: identifier,
      password: password,
    );
  }

  @override
  Future<void> logout() => _remoteDataSource.logout();
}
