import '../../domain/entities/user.dart';

/// Kontrak sumber data autentikasi.
abstract interface class AuthRemoteDataSource {
  Future<User> login({required String identifier, required String password});

  Future<User> register({
    required String name,
    required String identifier,
    required String password,
  });

  Future<void> logout();
}
