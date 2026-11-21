import '../../../../core/network/token_provider.dart';
import '../../domain/entities/user.dart';

/// Kontrak penyimpanan sesi login di perangkat.
abstract interface class SessionStorage implements TokenProvider {
  Future<User?> readSession();

  Future<void> saveSession(User user);

  Future<void> clearSession();

  @override
  Future<String?> readToken();
}
