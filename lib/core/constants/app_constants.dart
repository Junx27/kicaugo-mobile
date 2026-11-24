import 'app_flavor.dart';

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

  /// Pesan saat lokasi terkini tidak tersedia sebagai origin rute.
  static const String navigationOriginUnavailable =
      'Lokasi terkini belum tersedia. Rute dibuka dari tujuan saja.';

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

  /// Batas tunggu shimmer Beranda sebelum menawarkan muat ulang.
  static const Duration homeShimmerTimeout = Duration(seconds: 3);

  /// Jeda antar percobaan ulang selagi shimmer Beranda masih tampil.
  static const Duration homeRetryDelay = Duration(milliseconds: 400);

  /// Pesan saat pemuatan Beranda melewati batas tunggu shimmer.
  static const String homeLoadTimeout = 'Memuat data terlalu lama. Coba lagi.';

  /// Label tombol muat ulang.
  static const String retryLabel = 'Coba lagi';

  /// Flavor aktif hasil flag `--flavor` (default: [AppFlavor.dev]).
  static final AppFlavor flavor = currentFlavor;

  /// Alamat backend. Diubah lewat `--dart-define=API_BASE_URL=...` atau
  /// `env/<flavor>.json`; bawaan mengikuti flavor aktif.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: flavorName == productionFlavorName
        ? productionApiBaseUrl
        : flavorName == stgFlavorName
        ? stgApiBaseUrl
        : devApiBaseUrl,
  );

  /// Pakai data source API lewat `--dart-define=USE_API=true`.
  ///
  /// Bawaan: `false` untuk dev, `true` untuk stg/production.
  static const bool useApi = bool.fromEnvironment(
    'USE_API',
    defaultValue:
        flavorName == stgFlavorName || flavorName == productionFlavorName,
  );

  /// Batas waktu koneksi dan penerimaan respons API.
  static const Duration apiTimeout = Duration(seconds: 15);

  /// Pesan saat token tidak ada atau sudah kedaluwarsa.
  static const String apiUnauthorized = 'Sesi berakhir. Silakan masuk lagi.';

  /// Pesan saat koneksi melewati batas waktu.
  static const String apiTimeoutMessage = 'Koneksi timeout. Coba lagi.';

  /// Pesan saat perangkat tidak dapat menjangkau backend.
  static const String apiConnection =
      'Tidak dapat terhubung ke server. Periksa koneksi Anda.';

  /// Pesan saat bentuk respons tidak sesuai kontrak.
  static const String apiInvalidResponse = 'Respons server tidak dikenal.';

  /// Pesan saat backend gagal dengan status 4xx/5xx tanpa pesan detail.
  static const String apiDataFailure = 'Gagal memuat data. Coba lagi.';

  /// Pesan untuk kesalahan jaringan yang tidak dikenal.
  static const String apiUnexpected = 'Terjadi kesalahan. Coba lagi.';

  /// Asset lisensi font yang didaftarkan ke [LicenseRegistry].
  static const List<String> fontLicenseAssets = <String>[
    'assets/google_fonts/OFL-PlusJakartaSans.txt',
    'assets/google_fonts/OFL-Inter.txt',
  ];
}
