# KicauKu

Aplikasi mobile Flutter untuk komunitas burung kicau: melihat lomba terdekat,
mencari tempat penitipan, dan mengelola akun. Seluruh data masih **dummy**
(in-memory) sehingga aplikasi bisa dicoba tanpa backend.

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

## Di luar lingkup

Backend/API nyata, registrasi akun, Google Sign-In sungguhan, detail lomba,
booking penitipan, dan dark mode belum termasuk.
