# KicauGo

Aplikasi mobile Flutter untuk komunitas burung kicau: melihat lomba terdekat,
mencari tempat penitipan, dan mengelola akun.

Alur utama: **Splash → Login → Beranda** dengan bottom navigation 4 tab
(Beranda, Lomba, Penitipan, Profil).

## Prasyarat

- Flutter stable (diuji pada Flutter 3.38.6 / Dart 3.10.7)
- Simulator iOS atau emulator Android
- Koneksi internet untuk memuat gambar contoh dari `picsum.photos`

## Menjalankan

```bash
flutter pub get
flutter run -d <device-id>
```

Contoh:

```bash
flutter run -d "iPhone 16 Pro"   # simulator iOS
flutter run -d emulator-5554     # emulator Android
```

### Flavor

Ada tiga flavor: `dev`, `stg`, dan `production`. `dev` adalah default
(`default-flavor` di `pubspec.yaml`). Tiap flavor punya applicationId/bundle ID
dan nama aplikasi sendiri sehingga bisa terpasang berdampingan. Nilai
`env/<flavor>.json` dipakai lewat Makefile / VS Code; `flutter run` polos memakai
bawaan `AppConstants`.

```bash
make run-dev                       # atau: flutter run --flavor dev
make run-stg device=emulator-5554
make run-production

make build-apk-dev
make build-apk-stg
make build-apk-production

make pod-install                   # wajib setelah mengubah ios/Podfile
make build-ios-dev
make build-ios-stg
make build-ios-production
```

Nilai API per flavor ada di `env/dev.json`, `env/stg.json`, dan
`env/production.json`. Isinya diteruskan lewat `--dart-define-from-file`.
`FLUTTER_APP_FLAVOR` tidak ditaruh di file itu karena dikelola Flutter lewat
`--flavor`. `env/production.json` sengaja masuk `.gitignore` agar URL atau
secret produksi tidak ter-commit; salin `env/production.example.json` sebagai
pintasan awal. Jangan menaruh `LOG_COLOR` di file env — nilainya sudah menjadi
default kompilasi dan diatur lewat `--dart-define` bila perlu diubah.

Tile peta memakai proxy backend (`/api/v1/basemap/tiles/{z}/{x}/{y}`) yang
meneruskan ke CARTO Voyager. Token Bearer diset otomatis dari sesi login;
mobile tidak menyimpan key CARTO. Atribusi "OpenStreetMap contributors" dan
"CARTO" wajib tetap terlihat di peta.

Di **VS Code**, buka panel *Run and Debug*. Konfigurasi di `.vscode/launch.json`
terbagi tiga kelompok:

- `Flutter: DEV|STG|PRODUCTION (debug)` — debugger biasa, warna dimatikan
  (`LOG_COLOR=false`) karena Debug Console tidak merender ANSI.
- `Terminal: DEV|STG|PRODUCTION (warna)` — menjalankan `flutter run` di
  integrated terminal supaya warna ANSI tampil.
- `Attach: debugger ke app berjalan` — menyambungkan breakpoint ke aplikasi
  yang sudah berjalan di terminal.

Saat dijalankan, Flutter akan menanyakan device bila lebih dari satu tersedia.

| Flavor | applicationId / bundle ID suffix | Nama di device | API | Data source |
| --- | --- | --- | --- | --- |
| `dev` | `.dev` | `[DEV] KicauGo` | `http://localhost:8080` | API (`USE_API=true`) |
| `stg` | `.stg` | `[STG] KicauGo` | `https://stg-api.kicaugo.app` | API |
| `production` | tanpa suffix | KicauGo | `https://api.kicaugo.app` | API |

Flavor `dev` saat ini tersambung ke backend lokal. Pastikan backend berjalan
sebelum F5; kalau tidak, log `[ERR] ERROR` akan muncul dan form menampilkan
pesan koneksi. Untuk emulator Android, ganti `API_BASE_URL` di `env/dev.json`
menjadi `http://10.0.2.2:8080` (simulator iOS memakai `localhost`). Untuk
kembali ke data dummy, set `USE_API` menjadi `"false"`.

Akun backend untuk uji login: `user@example.com` / `stringst`. Endpoint
mengirim dan menerima envelope standar `{status, message, data}`; `ApiClient`
membuka `data` otomatis, jadi datasource tidak perlu tahu soal envelope.

### Akun demo

| Field | Nilai |
| --- | --- |
| Email | `demo@kicauku.app` |
| Sandi | `password123` |

Login bersifat dummy: email apa pun yang mengandung `@` dan sandi minimal
6 karakter akan diterima. Proses login sengaja diberi delay 1 detik untuk
menampilkan status loading.

## Fitur

- **Splash** tampil 2 detik lalu menuju login.
- **Login** memakai `Form` + `GlobalKey<FormState>`, validasi email dan sandi,
  toggle tampil/sembunyi sandi, serta layout scrollable (tidak overflow di
  layar 360x640 saat keyboard muncul).
- **Beranda** menampilkan sapaan "Halo, Budi 👋", kolom pencarian read-only,
  4 kartu lomba (horizontal) dengan badge "Hari Ini", dan 3 kartu penitipan.
  Gambar memakai `Image.network` dengan `loadingBuilder` dan `errorBuilder`.
- **Bottom navigation** 4 tab. State tiap tab dipertahankan oleh
  `StatefulShellRoute.indexedStack`.
- **Lomba / Penitipan / Profil** masih placeholder "Segera hadir".
  Profil memiliki tombol **Keluar** yang mengakhiri sesi dan kembali ke login.
- **Redirect router**: pengguna yang belum login diarahkan ke `/login`;
  pengguna yang sudah login dan membuka `/splash` atau `/login` diarahkan
  ke `/home`.

## Struktur

Arsitektur memakai **Clean Architecture + BLoC + get_it**. Aturan bisnis dan
kontrak data berada di `domain`, implementasi data dummy di `data`, state UI di
`presentation`, dan perakitan dependency di `di/service_locator.dart`.

```
lib/
├── main.dart                       # entrypoint: DI, lisensi font, runApp
├── app.dart                        # MaterialApp.router + BlocProvider
├── di/service_locator.dart         # composition root get_it
├── core/
│   ├── constants/app_constants.dart
│   ├── error/failure.dart          # Failure, AuthFailure, DataFailure
│   ├── router/app_router.dart      # GoRouter + bridge stream AuthBloc
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart          # ThemeData Material 3
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── coming_soon_view.dart
│       └── remote_image.dart
└── features/
    ├── splash/presentation/pages/splash_page.dart
    ├── auth/
    │   ├── domain/
    │   │   ├── entities/user.dart
    │   │   ├── repositories/auth_repository.dart
    │   │   └── usecases/login_usecase.dart, logout_usecase.dart
    │   ├── data/
    │   │   ├── datasources/auth_remote_data_source.dart,
    │   │   │               fake_auth_remote_data_source.dart
    │   │   └── repositories/auth_repository_impl.dart
    │   └── presentation/
    │       ├── bloc/auth_bloc.dart, auth_event.dart, auth_state.dart
    │       └── pages/login_page.dart
    ├── home/
    │   ├── domain/
    │   │   ├── entities/contest.dart, boarding_place.dart,
    │   │   │           home_content.dart
    │   │   ├── repositories/home_repository.dart
    │   │   └── usecases/get_home_content.dart
    │   ├── data/
    │   │   ├── datasources/home_data_source.dart,
    │   │   │               fake_home_data_source.dart
    │   │   └── repositories/home_repository_impl.dart
    │   └── presentation/
    │       ├── bloc/home_bloc.dart, home_event.dart, home_state.dart
    │       ├── main_shell.dart     # NavigationBar 4 tab
    │       ├── pages/home_page.dart
    │       └── widgets/
    │           ├── contest_card.dart
    │           ├── boarding_card.dart
    │           ├── home_search_bar.dart
    │           └── section_header.dart
    ├── contest/presentation/pages/contest_page.dart
    ├── boarding/presentation/pages/boarding_page.dart
    └── profile/presentation/pages/profile_page.dart
```

Route: `/splash`, `/login`, `/home`, `/contest`, `/boarding`, `/profile`.

### Alur state

1. `LoginPage` mengirim event `LoginSubmitted` ke `AuthBloc`; halaman tidak
   memegang status loading maupun navigasi.
2. `AuthBloc` memanggil `LoginUseCase` → `AuthRepository` →
   `FakeAuthRemoteDataSource`, lalu memancarkan `AuthStatus.authenticating`
   dan `AuthStatus.authenticated` (atau pesan kegagalan).
3. `AuthRouterNotifier` menjembatani stream `AuthBloc` ke `refreshListenable`
   milik `GoRouter`, sehingga redirect ke `/home` atau `/login` otomatis.
4. `HomePage` membuat `HomeBloc` dengan `GetHomeContent`; state loading,
   sukses, dan gagal (dengan tombol coba lagi) dibaca dari `HomeState`.


## Tema & tipografi

Semua token warna, ukuran font, dan radius dipusatkan di `core/theme`.
Tidak ada warna/ukuran/radius yang di-hardcode di halaman.

| Warna | Hex | Peran |
| --- | --- | --- |
| Primary | `#2E7D5B` | CTA, ikon aktif, harga |
| Accent | `#F5A623` | Badge "Hari Ini", rating |
| Background | `#F7FAF8` | Latar halaman |
| Surface | `#FFFFFF` | Kartu, input, app bar |
| Text primary | `#1F2A24` | Judul dan teks utama |
| Text secondary | `#6B7A72` | Teks pendukung |
| Border | `#E3EAE6` | Garis kartu/input 1px |
| Error | `#D64545` | Validasi |
| Success | `#3BA776` | Status berhasil |

Aturan bentuk: radius input/tombol 12, kartu 16, tinggi tombol 52,
padding halaman 24, kartu tanpa shadow tebal (border 1px).

Tipografi: heading **Plus Jakarta Sans** (24/Bold, 18/SemiBold, 16/SemiBold),
body **Inter** (14/Regular, 12/Regular, tombol 15/SemiBold).
Font di-bundle offline di `assets/google_fonts/` dan
`GoogleFonts.config.allowRuntimeFetching = false`, sehingga tidak ada
permintaan font saat runtime. Lisensi SIL OFL didaftarkan ke `LicenseRegistry`
di `main.dart` dan tersedia lewat halaman **About** Flutter.

> Setelah mengganti file font, lakukan stop lalu `flutter run` ulang —
> hot reload tidak memuat ulang font.

## Log debugging

Logging terpusat di `ApiLoggingInterceptor` (Dio) dan `AppNavigatorObserver`
(GoRouter). Berikut contoh keluaran **polos** (`LOG_COLOR=false`):

```
[BOOT] flavor=dev baseUrl=http://localhost:8080 useApi=true
[NAV] PUSH /login from /onboarding
[API] REQUEST POST http://localhost:8080/api/v1/auth/login
[API] HEADERS {"Authorization":"***","content-type":"application/json"}
[API] PAYLOAD
{
  "identifier": "user@example.com",
  "password": "***"
}
[API] RESPONSE 200 POST http://localhost:8080/api/v1/auth/login
{
  "status": 200,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "***"
  }
}
```

Versi **warna** (kode ANSI ditulis eksplisit di sini; di terminal kode itu
langsung dirender). Setiap baris JSON dibungkus sendiri supaya warnanya tidak
hilang di tengah output:

```
\x1B[32m[BOOT] flavor=dev baseUrl=http://localhost:8080 useApi=true\x1B[0m
\x1B[35m[NAV] PUSH /login from /onboarding\x1B[0m
\x1B[34m[API] REQUEST POST http://localhost:8080/api/v1/auth/login\x1B[0m
\x1B[34m[API] PAYLOAD\x1B[0m
\x1B[34m{\x1B[0m
\x1B[34m  "identifier": "user@example.com"\x1B[0m
\x1B[34m  "password": "***"\x1B[0m
\x1B[34m}\x1B[0m
\x1B[32m[API] RESPONSE 200 POST http://localhost:8080/api/v1/auth/login\x1B[0m
\x1B[32m{\x1B[0m
\x1B[32m  "status": 200\x1B[0m
\x1B[32m  "data": { ... }\x1B[0m
\x1B[32m}\x1B[0m
```

| Tag | Warna | Kode | Arti |
|---|---|---|---|
| `BOOT` | hijau | `\x1B[32m` | Konfigurasi awal: flavor, base URL, dan mode API/data dummy |
| `API` | biru | `\x1B[34m` | Request, header, dan payload |
| `API` 2xx | hijau | `\x1B[32m` | Respons sukses |
| `API` 4xx/5xx | merah | `\x1B[31m` | Respons gagal yang tetap diterima (`validateStatus`) |
| `ERR` | merah | `\x1B[31m` | `DioException`: status, pesan, dan body error |
| `NAV` | magenta | `\x1B[35m` | Navigasi/rute aplikasi |

Warna **aktif secara default** (`const bool.fromEnvironment('LOG_COLOR',
defaultValue: true)`). Matikan dengan `--dart-define=LOG_COLOR=false`.

### Alur kerja yang disarankan

1. **Lihat log berwarna** — jalankan konfigurasi `Terminal: DEV (warna)` (F5)
   atau dari terminal:

   ```bash
   flutter run --flavor dev --dart-define-from-file=env/dev.json
   ```

   `LOG_COLOR` tidak perlu ditulis karena default-nya `true`.
2. **Breakpoint sambil log berwarna** — jalankan `flutter run` seperti di atas
   di terminal, lalu di VS Code tekan F5 dan pilih
   `Attach: debugger ke app berjalan`. Masukkan VM Service URI yang muncul di
   terminal (biasanya `http://127.0.0.1:xxxxx/...`). Debugger VS Code lalu
   terhubung ke aplikasi yang masih berjalan di terminal.
3. **Debugger biasa tanpa warna** — pakai `Flutter: DEV (debug)` (serta varian
   STG/PRODUCTION). Konfigurasi ini sudah memakai `LOG_COLOR=false` karena
   Debug Console VS Code meng-escape ESC menjadi `\^[[32m`.

Catatan:

- `LOG_COLOR` bernilai tetap saat kompilasi; mengubahnya butuh **full restart**
  (hot reload tidak cukup).
- Konsol Xcode juga tidak merender ANSI. Bila menjalankan dari Xcode, pakai
  `LOG_COLOR=false`.
- Attach harus diulang setelah full restart karena VM Service URI berubah.
- Sink test selalu menerima teks polos, dan tidak ada log sama sekali di build
  release (`kDebugMode=false`).

Tag dan isi log:

- `[NAV] PUSH / POP` — halaman yang dibuka/ditutup beserta halaman
  sebelumnya/tujuannya.
- `[API] REQUEST` — method dan URL lengkap.
- `[API] HEADERS` — header request; nilai `Authorization` tetap `***`.
- `[API] PAYLOAD` — body request; kunci `password`, `token`, `accessToken`,
  `refreshToken`, `secret`, dan `apiKey` di-mask `***`, termasuk di dalam
  string JSON maupun map/list bertingkat.
- `[API] RESPONSE` — status code, method, URL, lalu body JSON rapi.
- `[ERR] ERROR` — status code, pesan error, lalu body JSON rapi.

Body dicetak dengan indentasi dua spasi oleh `prettyJson`; string JSON diurai
lebih dulu, string biasa ditampilkan apa adanya. Masking terjadi pada objek
hasil decode **sebelum** pretty-print, bukan pada string akhir. Body lebih dari
4000 karakter dipotong lalu diberi `... (truncated)`. Untuk mematikan sementara,
set `AppLogger.enabled = false`. `useApi=false` berarti tidak ada request HTTP;
form memakai data dummy, jadi yang tampil hanya baris `[BOOT]` dan `[NAV]`.

## Pengujian

```bash
dart format --set-exit-if-changed lib test integration_test test_driver
flutter analyze
flutter test                     # 66 unit/widget test
flutter test --coverage          # lcov: coverage/lcov.info
```

Integration test di simulator/emulator (menguji alur penuh dan mengambil
screenshot ke `build/screenshots/`):

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d <device-id>
```

Status verifikasi terakhir:

- `flutter analyze` bersih (no issues).
- 66 test lulus.
- Line coverage **100%** (604/604 baris) untuk seluruh file `lib/` yang
  tercatat di lcov (`main.dart` adalah entrypoint dan tidak dihitung).
- Integration test alur Splash → Login → 4 tab → Keluar lulus di
  **iPhone 16 Pro, iOS 18.6**.
- Gambar dari `picsum.photos` terverifikasi tampil di simulator; bila offline,
  `errorBuilder` menampilkan ikon fallback.

### Catatan iOS

- Deployment target iOS 15.0 (`ios/Podfile`).
- Di lingkungan Xcode 27, `flutter build ios --simulator` dapat gagal karena
  bug `lipo` saat memverifikasi arsitektur ganda. Gunakan `flutter run`
  (destination simulator spesifik) untuk menjalankan aplikasi.

## CI & Quality Gate

Workflow `.github/workflows/flutter-ci.yml` jalan pada `push` ke `master` dan
pada pull request (`opened`, `synchronize`, `reopened`). Urutan pemeriksaannya:

1. `dart format --output=none --set-exit-if-changed lib test`
2. `flutter analyze`
3. `flutter test --coverage` → menghasilkan `coverage/lcov.info`
4. `diff-cover coverage/lcov.info --compare-branch=origin/master --fail-under=100`
5. SonarCloud Scan → Quality Gate

Gate yang harus lolos sebelum PR di-merge:

| Gate | Syarat |
| --- | --- |
| Format | Tidak ada file yang berubah setelah `dart format` |
| Analyze | `No issues found!` |
| Test | Semua unit/widget test lulus |
| Coverage baris baru | **100%** terhadap `origin/master` (`diff-cover`) |
| SonarCloud Quality Gate | **Security Rating on New Code ≥ A** |

### Konfigurasi SonarCloud

Tersimpan di `sonar-project.properties` dan di workflow:

- Host: `https://sonarcloud.io`
- Organization: `junx27`
- Project key: `Junx27_kicaugo-mobile`
- Sumber `lib`, test `test`, laporan coverage `coverage/lcov.info`
- File generated (`*.g.dart`, `*.freezed.dart`, `generated/`) dikecualikan

Secret GitHub Actions yang dipakai:

- `SONAR_TOKEN` — token autentikasi SonarCloud (wajib)
- `GITHUB_TOKEN` — disediakan otomatis oleh GitHub

Action `SonarSource/sonarcloud-github-action` di-pin ke full commit SHA, bukan
tag `@master`, karena SonarCloud menandai tag floating sebagai temuan security
pada kode CI.

### Warning baseline `master`

Pada project yang baru terhubung, SonarCloud bisa menampilkan:

```text
Warning: 'master' branch has not been analyzed yet.
```

Ini **bukan kegagalan scan** — analisis PR tetap berjalan dan check tetap pass.
Artinya SonarCloud belum punya baseline branch `master` sebagai pembanding
*New Code*, karena workflow baru pernah jalan di branch PR. Baseline terbentuk
setelah PR di-merge: push ke `master` memicu workflow, lalu warning hilang.

Catatan: pada analisis pertama `master`, SonarCloud dapat menganggap sebagian
besar kode sebagai *New Code*. Pastikan tidak ada temuan security lain agar
Quality Gate tetap lolos saat baseline dibentuk.

## Di luar lingkup

Backend/API nyata, registrasi akun, Google Sign-In sungguhan, detail lomba,
booking penitipan, dan dark mode belum termasuk.
