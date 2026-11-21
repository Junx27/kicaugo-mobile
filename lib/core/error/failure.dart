/// Kegagalan bisnis atau data yang bisa ditampilkan ke pengguna.
sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;
}

/// Kegagalan saat autentikasi.
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Kegagalan saat memuat data.
final class DataFailure extends Failure {
  const DataFailure(super.message);
}
