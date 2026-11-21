import '../entities/user.dart';

/// Kontrak akses data autentikasi.
abstract interface class AuthRepository {
  Future<User> login({required String identifier, required String password});

  Future<User> register({
    required String name,
    required String identifier,
    required String password,
  });

  Future<void> logout();
}
