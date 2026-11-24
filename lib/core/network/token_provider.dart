/// Sumber token Bearer untuk request API.
abstract interface class TokenProvider {
  /// Mengembalikan null bila belum ada sesi aktif.
  Future<String?> readToken();

  /// Akses sinkron ke token yang tersimpan (null bila belum ada).
  ///
  /// Dipakai oleh komponen yang membutuhkan header sinkron (mis. tile provider
  /// peta), yang tidak dapat menunggu Future.
  String? get accessToken;
}
