/// Path route aplikasi, didefinisikan sekali agar tidak ada literal berulang.
abstract final class AppRoutes {
  /// Splash screen, rute awal aplikasi.
  static const String splash = '/splash';

  /// Onboarding tiga slide setelah splash.
  static const String onboarding = '/onboarding';

  /// Masuk akun.
  static const String login = '/login';

  /// Daftar akun baru.
  static const String register = '/register';

  /// Tab Beranda (rute utama setelah masuk).
  static const String home = '/home';

  /// Tab Jadwal.
  static const String schedule = '/schedule';

  /// Tab Tiket Saya.
  static const String tickets = '/tickets';

  /// Tab Komunitas.
  static const String community = '/community';

  /// Tab Chat.
  static const String chat = '/chat';

  /// Tab Profil.
  static const String profile = '/profile';

  /// Pusat bantuan dan kontak panitia.
  static const String helpCenter = '/help-center';

  /// Pengingat rawatan dan alarm lomba.
  static const String reminders = '/reminders';

  /// Riwayat tiket gantangan dan invoice.
  static const String ticketHistory = '/ticket-history';

  /// Halaman peta penuh lokasi venue lomba.
  static const String venueMap = '/venue-map';

  /// Rute yang boleh dibuka tanpa sesi.
  static const Set<String> publicRoutes = <String>{
    splash,
    onboarding,
    login,
    register,
  };
}
