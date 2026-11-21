// Konfigurasi flavor build aplikasi.
//
// Nama flavor disuntikkan Flutter lewat `--flavor` (atau `default-flavor`
// di pubspec) sebagai environment `FLUTTER_APP_FLAVOR`. Nilai bawaan dipakai
// saat menjalankan perintah tanpa flavor, misalnya `flutter test`.

/// Nama flavor development.
const String devFlavorName = 'dev';

/// Nama flavor staging.
const String stgFlavorName = 'stg';

/// Nama flavor produksi.
const String productionFlavorName = 'production';

/// Nama flavor aktif hasil flag `--flavor`.
const String flavorName = String.fromEnvironment(
  'FLUTTER_APP_FLAVOR',
  defaultValue: devFlavorName,
);

/// Alamat backend bawaan development (emulator Android).
const String devApiBaseUrl = 'http://10.0.2.2:8080';

/// Alamat backend bawaan staging (placeholder, diganti di `env/stg.json`).
const String stgApiBaseUrl = 'https://stg-api.kicaugo.app';

/// Alamat backend bawaan produksi (placeholder, diganti di `env/production.json`).
const String productionApiBaseUrl = 'https://api.kicaugo.app';

/// Flavor yang didukung aplikasi.
enum AppFlavor {
  dev(devApiBaseUrl, false),
  stg(stgApiBaseUrl, true),
  production(productionApiBaseUrl, true);

  const AppFlavor(this.defaultApiBaseUrl, this.defaultUseApi);

  /// Alamat backend bawaan bila `API_BASE_URL` tidak diisi.
  final String defaultApiBaseUrl;

  /// Flag bawaan pemakaian API bila `USE_API` tidak diisi.
  final bool defaultUseApi;

  /// Mengubah [name] menjadi [AppFlavor].
  ///
  /// Nama kosong atau tidak dikenal jatuh ke [AppFlavor.dev].
  static AppFlavor fromName(String? name) => switch (name) {
    stgFlavorName => AppFlavor.stg,
    productionFlavorName => AppFlavor.production,
    _ => AppFlavor.dev,
  };
}

/// Flavor aktif berdasarkan [flavorName].
final AppFlavor currentFlavor = AppFlavor.fromName(flavorName);
