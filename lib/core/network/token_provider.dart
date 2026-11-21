/// Sumber token Bearer untuk request API.
abstract interface class TokenProvider {
  /// Mengembalikan null bila belum ada sesi aktif.
  Future<String?> readToken();
}
