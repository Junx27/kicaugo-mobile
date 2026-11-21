/// Konstanta aplikasi yang mudah diganti.
abstract final class AppConstants {
  /// Bagian awal nama aplikasi.
  static const String appNameLead = 'Kicau';

  /// Bagian akhir nama aplikasi (ditampilkan berwarna primary).
  static const String appNameAccent = 'Go';

  /// Nama aplikasi.
  static const String appName = '$appNameLead$appNameAccent';

  /// Tagline aplikasi di splash.
  static const String appTagline =
      'Info lomba burung & tiket dalam satu genggaman';

  /// Label versi aplikasi (selaraskan dengan `version` di pubspec).
  static const String appVersionLabel = 'VERSI 1.0';

  /// Eyebrow komunitas di splash.
  static const String splashEyebrow = 'KOMUNITAS KICAU MANIA';

  /// Teks status pemuatan di splash.
  static const String splashLoading = 'Menyiapkan Arena...';

  /// Label badge kecil pada maskot splash.
  static const String splashProBadge = 'PRO';

  /// Lama splash sebelum pindah halaman.
  static const Duration splashDuration = Duration(seconds: 2);

  /// Asset gambar maskot burung.
  static const String mascotAsset = 'assets/images/mascot.svg';

  /// Asset maskot burung bertengger (onboarding).
  static const String mascotPerchAsset = 'assets/images/mascot_perch.svg';

  /// Logo "G" Google untuk tombol masuk cepat.
  static const String googleLogoAsset = 'assets/images/google_logo.svg';

  /// Teks placeholder untuk fitur yang belum tersedia.
  static const String comingSoon = 'Segera hadir';

  /// Pesan gagal login dummy.
  static const String loginFailure =
      'Email/nomor WhatsApp atau kata sandi salah';

  /// Pesan gagal daftar akun dummy.
  static const String registerFailure =
      'Pendaftaran gagal. Periksa kembali data Anda.';

  /// Pesan daftar dengan identifier yang sudah dipakai.
  static const String accountExists =
      'Email atau nomor WhatsApp sudah terdaftar';

  /// Pesan gagal memuat Beranda.
  static const String homeLoadError = 'Gagal memuat data. Coba lagi.';

  /// Label tombol muat ulang.
  static const String retryLabel = 'Coba lagi';

  /// Asset lisensi font yang didaftarkan ke [LicenseRegistry].
  static const List<String> fontLicenseAssets = <String>[
    'assets/google_fonts/OFL-PlusJakartaSans.txt',
    'assets/google_fonts/OFL-Inter.txt',
  ];
}
