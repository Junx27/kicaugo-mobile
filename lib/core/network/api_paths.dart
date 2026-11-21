/// Path endpoint API v1 yang dipakai aplikasi.
abstract final class ApiPaths {
  static const String _prefix = '/api/v1';

  static const String login = '$_prefix/auth/login';
  static const String register = '$_prefix/auth/register';
  static const String logout = '$_prefix/auth/logout';
  static const String me = '$_prefix/auth/me';
  static const String home = '$_prefix/home';
}
