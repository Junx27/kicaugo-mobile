import '../../domain/entities/user.dart';

/// Kontrak penyimpanan sesi login di perangkat.
abstract interface class SessionStorage {
  Future<User?> readSession();

  Future<void> saveSession(User user);

  Future<void> clearSession();
}
