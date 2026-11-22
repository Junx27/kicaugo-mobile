/// Path endpoint API v1 yang dipakai aplikasi.
abstract final class ApiPaths {
  static const String _prefix = '/api/v1';

  // Auth
  static const String login = '$_prefix/auth/login';
  static const String register = '$_prefix/auth/register';
  static const String logout = '$_prefix/auth/logout';
  static const String me = '$_prefix/auth/me';

  // Home
  static const String home = '$_prefix/home';
  static const String homeProfile = '$_prefix/home/profile';
  static const String homeFeatured = '$_prefix/home/featured';
  static const String homeBirdCategories = '$_prefix/home/bird-categories';

  // Home (per bagian, cadangan)
  static const String homeUpcoming = '$_prefix/home/upcoming';
  static const String homeStats = '$_prefix/home/stats';
  static const String homeActiveTicket = '$_prefix/home/active-ticket';
  static const String homeSchedules = '$_prefix/home/schedules';

  // Profile
  static const String meProfileCurrentLocation =
      '$_prefix/me/profile/current-location';
}
