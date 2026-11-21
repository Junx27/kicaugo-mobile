# DEVELOPMENT.md — Alur Membuat Fitur Halaman

Panduan global untuk membuat satu fitur halaman di aplikasi ini: **dari
pengambilan data sampai data tampil di halaman**. Berlaku untuk semua fitur
baru, bukan hanya Profil.

Dokumen ini menjawab satu pertanyaan:

> "Saya mau bikin halaman baru. Mulai dari mana, urutannya bagaimana, dan di
> file mana saja kodenya ditaruh?"

---

## 1. Prinsip yang dipakai

1. **Feature-first + Clean Architecture ringan.**
   Satu fitur punya folder sendiri berisi `domain`, `data`, dan `presentation`.
2. **Aturan dependensi satu arah.**
   `presentation → domain ← data`. Domain tidak boleh mengimpor Flutter,
   data source, atau widget.
3. **UI tidak pernah mengambil data sendiri.**
   Widget tidak memanggil repository/data source. Widget hanya membaca state
   dan mengirim aksi ke Cubit/Bloc.
4. **Data dummy dulu, API menyusul.**
   Halaman bisa jadi dan diuji sebelum backend ada. Saat API siap, hanya
   lapisan `data` yang berubah.
5. **State async harus eksplisit.**
   Minimal: `initial`, `loading`, `success`, `failure` (+ `empty` bila perlu).
   Failure selalu punya pesan yang bisa ditampilkan dan aksi coba lagi.
6. **Teks dan tema tidak di-hardcode.**
   Teks statis di `<fitur>_strings.dart`; warna, radius, font, shadow di
   `core/theme`.
7. **Test scoped.**
   Test hanya untuk fitur yang diubah, bukan seluruh aplikasi.

---

## 2. Peta lapisan

| Lapisan | Folder | Isi | Tanggung jawab | Tidak boleh |
|---|---|---|---|---|
| Domain | `lib/features/<fitur>/domain/` | `entities/`, `repositories/` (abstract), `usecases/` | Bentuk data & aturan bisnis | Impor Flutter, widget, HTTP |
| Data | `lib/features/<fitur>/data/` | `datasources/`, `repositories/` (impl) | Ambil data dari fake/API, mapping, melempar `Failure` | Tahu tentang Cubit/widget |
| Presentation | `lib/features/<fitur>/presentation/` | `cubit/` atau `bloc/`, `pages/`, `widgets/`, `<fitur>_strings.dart` | State UI, tampilan, aksi pengguna | Memanggil datasource langsung |
| Core | `lib/core/` | `theme/`, `widgets/`, `error/`, `router/`, `constants/` | Komponen & konfigurasi lintas fitur | Bergantung pada satu fitur |

Struktur minimal satu fitur:

```text
lib/features/<fitur>/
├── domain/
│   ├── entities/<fitur>_content.dart
│   ├── repositories/<fitur>_repository.dart
│   └── usecases/get_<fitur>_content.dart
├── data/
│   ├── datasources/<fitur>_data_source.dart
│   ├── datasources/fake_<fitur>_data_source.dart
│   └── repositories/<fitur>_repository_impl.dart
└── presentation/
    ├── cubit/<fitur>_state.dart
    ├── cubit/<fitur>_cubit.dart
    ├── pages/<fitur>_page.dart
    ├── widgets/...
    └── <fitur>_strings.dart
```

---

## 3. Alur data end-to-end

### Saat halaman pertama kali dibuka

```text
Route (GoRouter)
  └→ <Fitur>Page
       └→ BlocProvider(create: <Fitur>Cubit(Get<Fitur>Content)..load())
            └→ Cubit.load()
                 ├→ emit(loading)        → UI: spinner
                 └→ UseCase()
                      └→ Repository (abstract)
                           └→ RepositoryImpl
                                └→ DataSource
                                     ├→ Fake (demo)  ─┐
                                     └→ API (nanti)   ─┴→ Entity
                 ├→ emit(success, data)  → UI: konten
                 └→ emit(failure, pesan) → UI: LoadErrorView + Coba lagi
```

### Saat pengguna melakukan aksi

```text
Tap / submit
  └→ context.read<<Fitur>Cubit>().aksi()
       └→ UseCase → Repository → DataSource
            └→ emit(state baru)
                 └→ BlocBuilder / BlocSelector → widget rebuild
```

Aturan penting:

- **Satu sumber kebenaran**: data yang tampil berasal dari `state`, bukan
  variabel lokal widget.
- **Navigasi bukan tugas Cubit.** Cubit mengubah state; halaman yang memutuskan
  `context.go(...)` bila perlu.
- **Logout / sesi global** memakai `AuthBloc` yang sudah disediakan di root
  (`app.dart`), bukan membuat bloc auth baru.

---

## 4. Langkah 0 — Tentukan kontrak halaman

Sebelum menulis kode, tulis di issue/PR:

1. **Data yang dibutuhkan** — field dan tipenya.
2. **Aksi pengguna** — apa efeknya: memuat ulang, membuka halaman, mengubah
   state, atau belum tersedia ("Segera hadir").
3. **State** — perlu `empty`? perlu `refreshing`?
4. **Sumber data** — fake dulu atau API.
5. **Key** — elemen yang akan diuji dan di-tap otomatis.

Contoh ringkas:

| Kebutuhan | Keputusan |
|---|---|
| Daftar jadwal + filter | `ScheduleContent { List<ScheduleItem> items }` |
| Aksi filter | state `selectedFilter`, cubit method `selectFilter` |
| Aksi detail | navigasi ke `/schedule/:id` |
| Aksi belum ada | `showComingSoon(context)` |
| Key | `schedule_filter_all`, `schedule_item_<id>` |

---

## 5. Langkah 1 — Entity (domain)

Entity adalah bentuk data yang dibaca UI. Immutable, `Equatable`, tanpa
dependensi Flutter.

```dart
import 'package:equatable/equatable.dart';

enum ScheduleStatus { open, full, finished }

class ScheduleItem extends Equatable {
  const ScheduleItem({
    required this.id,
    required this.title,
    required this.status,
    this.location,
  });

  final String id;
  final String title;
  final ScheduleStatus status;
  final String? location;

  @override
  List<Object?> get props => [id, title, status, location];
}

class ScheduleContent extends Equatable {
  const ScheduleContent({required this.items});

  final List<ScheduleItem> items;

  @override
  List<Object?> get props => [items];
}
```

Checklist entity:

- [ ] Semua field `final`.
- [ ] `const` constructor bila memungkinkan.
- [ ] `props` memuat **semua** field.
- [ ] Status memakai `enum`, bukan string bebas.
- [ ] Tidak ada `BuildContext`, `Color`, atau tipe Flutter lain.

---

## 6. Langkah 2 — Repository contract + usecase

Repository abstract adalah kontrak data. Usecase adalah pintu masuk yang
dipanggil Cubit.

```dart
// domain/repositories/schedule_repository.dart
abstract class ScheduleRepository {
  Future<ScheduleContent> fetchSchedule();
}
```

```dart
// domain/usecases/get_schedule_content.dart
class GetScheduleContent {
  const GetScheduleContent(this._repository);

  final ScheduleRepository _repository;

  Future<ScheduleContent> call() => _repository.fetchSchedule();
}
```

Aturan:

- Satu method repository = satu kebutuhan data yang jelas.
- Usecase diberi nama sesuai aksi (`Get...`, `Submit...`, `Update...`).
- Jangan bocorkan tipe data layer (JSON, response HTTP) ke domain.

---

## 7. Langkah 3 — Data source + fake + repository impl

### 7.1 Kontrak data source

```dart
// data/datasources/schedule_data_source.dart
import '../../domain/entities/schedule_content.dart';

abstract class ScheduleDataSource {
  Future<ScheduleContent> fetchSchedule();
}
```

### 7.2 Fake data source (wajib untuk tahap demo/test)

```dart
// data/datasources/fake_schedule_data_source.dart
class FakeScheduleDataSource implements ScheduleDataSource {
  const FakeScheduleDataSource({
    this.delay = const Duration(milliseconds: 400),
  });

  final Duration delay;

  static const ScheduleContent content = ScheduleContent(
    items: <ScheduleItem>[
      ScheduleItem(id: '1', title: 'Latpres Cibubur', status: ScheduleStatus.open),
    ],
  );

  @override
  Future<ScheduleContent> fetchSchedule() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return content;
  }
}
```

Catatan:

- `static const content` memudahkan test memakai data yang sama.
- `delay` bisa diatur; saat test selalu `Duration.zero`.
- Untuk simulasi kegagalan, **jangan** taruh flag di fake produksi. Buat
  repository palsu di folder test (lihat Langkah 10).

### 7.3 Repository impl

```dart
// data/repositories/schedule_repository_impl.dart
class ScheduleRepositoryImpl implements ScheduleRepository {
  const ScheduleRepositoryImpl(this._dataSource);

  final ScheduleDataSource _dataSource;

  @override
  Future<ScheduleContent> fetchSchedule() => _dataSource.fetchSchedule();
}
```

### 7.4 Melempar error yang bisa ditampilkan

Data layer hanya boleh melempar `Failure` dari `core/error/failure.dart`:

```dart
if (response.statusCode != 200) {
  throw const DataFailure('Gagal memuat jadwal. Coba lagi.');
}
```

Jangan biarkan `Exception` mentah naik ke Cubit.

---

## 8. Langkah 4 — State + Cubit/Bloc

### Cubit atau Bloc?

| Kebutuhan | Pilihan |
|---|---|
| Satu alur utama: load, retry, refresh | **Cubit** (default untuk halaman baru) |
| Banyak event berbeda dengan payload kompleks | **Bloc** |
| Perlu audit event / logika event terpisah | **Bloc** |
| State dipakai lintas halaman (sesi, badge nav) | Bloc/Cubit di level shell/root |

Contoh di repo: `ProfileCubit` dan `TicketsCubit` memakai Cubit; `AuthBloc`
dan `HomeBloc` memakai Bloc karena banyak event dan state-nya dipakai lintas
widget.

### 8.1 State

```dart
// presentation/cubit/schedule_state.dart
enum ScheduleStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.content,
    this.message,
  });

  final ScheduleStatus status;
  final ScheduleContent? content;
  final String? message;

  @override
  List<Object?> get props => [status, content, message];
}
```

Bila butuh state tambahan (filter, pencarian), tambahkan field baru dan
masukkan ke `props`. Jangan menyimpan state turunan yang bisa dihitung dari
`content`.

### 8.2 Cubit

```dart
// presentation/cubit/schedule_cubit.dart
class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this._getScheduleContent) : super(const ScheduleState());

  final GetScheduleContent _getScheduleContent;

  Future<void> load() async {
    emit(const ScheduleState(status: ScheduleStatus.loading));
    try {
      final content = await _getScheduleContent();
      emit(ScheduleState(status: ScheduleStatus.success, content: content));
    } on Failure catch (failure) {
      emit(
        ScheduleState(
          status: ScheduleStatus.failure,
          message: failure.message,
        ),
      );
    }
  }
}
```

Checklist Cubit:

- [ ] `load()` meng-emit `loading` lebih dulu.
- [ ] Hanya menangkap `Failure`, bukan semua `Object`.
- [ ] Retry = panggil `load()` lagi (tidak perlu method terpisah).
- [ ] Tidak menyimpan `BuildContext`, navigator, atau widget.
- [ ] Tidak melakukan `emit` setelah `close()` (hindari async tanpa cek
      `isClosed` bila operasi bisa selesai terlambat).

---

## 9. Langkah 5 — Sambungkan dependency ke halaman

Ada dua pola yang sudah dipakai di repo. Pilih salah satu, jangan campur
dalam satu fitur.

### Pola A — get_it / DI (dipakai Beranda & Auth)

Cocok bila data dipakai lintas widget/halaman atau akan segera memakai API.

```dart
// lib/di/service_locator.dart
getIt
  ..registerLazySingleton<ScheduleDataSource>(
    () => const FakeScheduleDataSource(),
  )
  ..registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(getIt()),
  )
  ..registerLazySingleton(() => GetScheduleContent(getIt()));
```

Lalu alirkan dari `main.dart` → `app.dart` → router → halaman:

```dart
// main.dart
KicauKuApp(
  authBloc: getIt<AuthBloc>(),
  getHomeContent: getIt<GetHomeContent>(),
  getScheduleContent: getIt<GetScheduleContent>(), // tambahan
);
```

```dart
// app.dart → createRouter(...)
createRouter(
  authBloc: widget.authBloc,
  getHomeContent: widget.getHomeContent,
  getScheduleContent: widget.getScheduleContent, // teruskan
  refreshListenable: _refreshNotifier,
);
```

```dart
// core/router/app_router.dart
_branch(
  AppRoutes.schedule,
  (context, state) => SchedulePage(
    getScheduleContent: getScheduleContent, // dari parameter createRouter
  ),
),
```

### Pola B — default parameter di halaman (dipakai Profil & Tiket)

Cocok untuk halaman mandiri/prototipe; test tetap bisa menyuntik sumber lain.

```dart
class SchedulePage extends StatelessWidget {
  const SchedulePage({
    super.key,
    this.getScheduleContent = const GetScheduleContent(
      ScheduleRepositoryImpl(FakeScheduleDataSource()),
    ),
  });

  final GetScheduleContent getScheduleContent;
  // ...
}
```

| Aspek | Pola A (DI) | Pola B (default param) |
|---|---|---|
| Ganti fake → API | 1 tempat (service locator) | ubah default di halaman |
| Data dipakai halaman lain | mudah | perlu oper parameter |
| Boilerplate | lebih banyak | minimal |
| Test | inject lewat konstruktor | inject lewat konstruktor |
| Rekomendasi | fitur produksi / shared state | halaman demo / page-scoped |

Yang **tidak boleh**: halaman membuat `FakeXDataSource()` di dalam `build()`
atau memanggil `GetIt` langsung dari widget. Injeksi harus lewat konstruktor
atau provider.

---

## 10. Langkah 6 — Strings dan tema

### 10.1 Strings

```dart
// presentation/schedule_strings.dart
abstract final class ScheduleStrings {
  static const String title = 'Jadwal';
  static const String empty = 'Belum ada jadwal.';
  static String itemCount(int count) => '$count jadwal ditemukan';
}
```

- Teks statis **tidak boleh** ditulis langsung di widget.
- Teks yang berasal dari data (nama burung, judul lomba) tetap dari entity.
- Format dinamis memakai `static String fungsi(...)`, bukan `+` di widget.

### 10.2 Tema

Gunakan token yang sudah ada:

| Kebutuhan | Sumber |
|---|---|
| Warna | `AppColors` |
| Tone pastel | `AppTones.yellow/lime/periwinkle/pink` (`gradient`, `foreground`, `light`) |
| Teks | `AppTextStyles.pageTitle/sectionTitle/title/headline/body/caption/label/eyebrow/button` |
| Radius, shadow, padding | `AppTheme.panelRadius/cardRadius/pillRadius/softShadow/raisedShadow/pagePadding` |

Aturan visual:

- Maksimal **3 tone pastel** per layar.
- Jangan menulis `Color(0xFF...)` atau `TextStyle(fontSize: ...)` di widget.
- Gunakan `RemoteImage` untuk gambar jaringan (sudah punya loading &
  fallback), bukan `Image.network` mentah.

---

## 11. Langkah 7 — Widget

Pecah dari komponen terkecil ke besar. Satu file = satu tanggung jawab.

Urutan yang disarankan:

1. Tombol/pill reusable.
2. Header section.
3. Kartu item.
4. Grid/list section.
5. Baru dirakit di halaman.

Aturan widget:

- Widget privat (`_Nama`) boleh berada di file yang sama bila hanya dipakai
  di situ; widget reusable dipisah ke `widgets/`.
- Widget menerima **data siap pakai**, bukan `BuildContext` untuk mengambil
  data sendiri.
- Aksi yang belum tersedia memakai `showComingSoon(context)` dari
  `core/widgets/app_snack_bar.dart`.
- Beri `Key` pada elemen yang diuji/di-tap otomatis.

---

## 12. Langkah 8 — Halaman

Halaman punya dua bagian: **penyedia state** dan **tampilan state**.

```dart
class SchedulePage extends StatelessWidget {
  const SchedulePage({
    super.key,
    this.getScheduleContent = const GetScheduleContent(
      ScheduleRepositoryImpl(FakeScheduleDataSource()),
    ),
  });

  final GetScheduleContent getScheduleContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleCubit(getScheduleContent)..load(),
      child: const _ScheduleView(),
    );
  }
}
```

```dart
class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceLavender,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TitleTopBar(title: ScheduleStrings.title),
            Expanded(
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) => switch (state.status) {
                  ScheduleStatus.initial || ScheduleStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  ScheduleStatus.failure => LoadErrorView(
                    message: state.message ?? AppConstants.homeLoadError,
                    onRetry: () => context.read<ScheduleCubit>().load(),
                  ),
                  ScheduleStatus.success => _ScheduleContent(
                    content: state.content!,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Checklist halaman:

- [ ] `BlocProvider` membuat Cubit **sekali** dan memanggil `load()`.
- [ ] `switch` state **exhaustive** (tanpa `default`).
- [ ] Failure memakai `LoadErrorView` + retry, bukan teks mentah.
- [ ] Konten sukses memakai scroll (`SingleChildScrollView`/`ListView`) dan
      bottom padding `112` bila ada navigasi mengambang.
- [ ] `context.read` untuk aksi, `BlocBuilder`/`BlocSelector` untuk membaca.
- [ ] Data lintas bloc memakai `BlocSelector` (contoh: nama user dari
      `AuthBloc`), bukan menyimpan salinan di state lokal.
- [ ] Tidak ada logika data di widget.

### `SingleChildScrollView` vs `ListView`

- `ListView`/`ListView.builder` **lazy**: widget di luar layar belum dibangun,
  sehingga `find.byKey` dan `ensureVisible` bisa gagal.
- Untuk halaman pendek dengan aksi penting di bawah, gunakan
  `SingleChildScrollView` + `Column`.
- Untuk daftar panjang, gunakan `ListView`, tapi test harus `scrollUntilVisible`
  alih-alih `ensureVisible`.

### Bila halaman sudah punya UI (retrofit)

Kalau tampilan sudah dibuat dan baru ingin disambungkan ke data:

1. Ganti data contoh di widget menjadi parameter/entity.
2. Buat entity + Cubit sesuai kontrak UI.
3. Bungkus halaman dengan `BlocProvider` dan ganti data hardcoded dengan
   `state.content!`.
4. Pertahankan `Key` yang sudah dipakai test.
5. Tambahkan state loading/failure di sekitar konten yang sudah ada.

---

## 13. Langkah 9 — Routing

### Kasus A — tab baru di navigasi utama

```dart
// core/router/app_router.dart
_branch(AppRoutes.schedule, (context, state) => const SchedulePage()),
```

Lalu tambahkan `PillNavItem` di `main_shell.dart` dan pastikan urutan
`currentIndex` sesuai urutan branch.

### Kasus B — halaman detail

```dart
GoRoute(
  path: '/schedule/:id',
  builder: (context, state) => ScheduleDetailPage(
    id: state.pathParameters['id']!,
  ),
),
```

Aturan:

- Rute privat otomatis dialihkan ke login oleh `authRedirect`; pastikan path
  tidak masuk `AppRoutes.publicRoutes` kecuali memang publik.
- Halaman detail menerima **id**, bukan seluruh entity, agar bisa memuat data
  sendiri dan tetap valid setelah refresh.
- Jangan menaruh `BuildContext` di Cubit; navigasi dilakukan di widget.

---

## 14. Langkah 10 — Test

Test minimum untuk satu fitur halaman:

| Jenis | File | Yang diuji |
|---|---|---|
| Data | `test/features/<fitur>/data/..._test.dart` | fake mengembalikan data, repo meneruskan, usecase memanggil repo, entity equality |
| Cubit | `test/features/<fitur>/presentation/cubit/..._test.dart` | urutan state `loading → success`, `loading → failure + pesan` |
| Halaman | `test/features/<fitur>/presentation/pages/..._test.dart` | loading, sukses, gagal + retry, aksi, key, teks penting |

### 14.1 Fakes test

```dart
/// test/features/schedule/<fitur>_fakes.dart
class FakeScheduleRepository implements ScheduleRepository {
  FakeScheduleRepository({
    this.failuresRemaining = 0,
    this.delay = Duration.zero,
  });

  int failuresRemaining;
  final Duration delay;
  int fetchCalls = 0;

  @override
  Future<ScheduleContent> fetchSchedule() async {
    fetchCalls++;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure('Gagal memuat jadwal');
    }
    return FakeScheduleDataSource.content;
  }
}

/// Untuk menguji state loading tanpa timer.
class CompleterScheduleRepository implements ScheduleRepository {
  CompleterScheduleRepository(this.completer);
  final Completer<ScheduleContent> completer;

  @override
  Future<ScheduleContent> fetchSchedule() => completer.future;
}
```

### 14.2 Test Cubit

```dart
blocTest<ScheduleCubit, ScheduleState>(
  'memuat lalu success',
  build: () => ScheduleCubit(GetScheduleContent(FakeScheduleRepository())),
  act: (cubit) => cubit.load(),
  expect: () => [
    const ScheduleState(status: ScheduleStatus.loading),
    const ScheduleState(
      status: ScheduleStatus.success,
      content: FakeScheduleDataSource.content,
    ),
  ],
);
```

### 14.3 Test halaman

Pola yang wajib diikuti:

```dart
testWidgets('loading lalu menampilkan data', (tester) async {
  final completer = Completer<ScheduleContent>();

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: SchedulePage(
          getScheduleContent: GetScheduleContent(
            CompleterScheduleRepository(completer),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  expect(find.byType(CircularProgressIndicator), findsOneWidget);

  completer.complete(FakeScheduleDataSource.content);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 2));

  expect(find.text('Latpres Cibubur'), findsOneWidget);
});
```

Aturan test halaman:

- **Loading** diuji dengan `Completer`, bukan `Future.delayed` (menghindari
  "pending timer").
- **Viewport tinggi** (`tester.view.physicalSize = const Size(420, 3600)`)
  untuk halaman panjang.
- **`ensureVisible` sebelum tap** elemen di bawah layar.
- Aksi berulang diuji berparameter:

  ```dart
  final targets = <String, Finder Function()>{
    'filter': () => find.byKey(const Key('schedule_filter')),
    'detail': () => find.byKey(const Key('schedule_item_1')),
  };
  targets.forEach((name, finder) {
    testWidgets('$name berfungsi', (tester) async { /* ... */ });
  });
  ```

- Test yang memasang gambar jaringan palsu: set
  `debugNetworkImageHttpClientProvider` dan reset dengan `try/finally` **di
  dalam body test**. Jangan reset lewat `addTearDown` — invariant painting
  dicek sebelum tearDown berjalan.
- Untuk halaman di dalam shell/tab, gunakan helper
  `test/support/pump_app.dart` (`pumpKicauKuApp`, `createAuthBloc`,
  `tapVisible`, `pumpNavigation`).

---

## 15. Langkah 11 — Verifikasi

Jalankan hanya untuk fitur yang diubah:

```bash
dart format lib/features/<fitur> test/features/<fitur>
flutter analyze
flutter test test/features/<fitur>
```

Bila navigasi/tab berubah, tambahkan test router:

```bash
flutter test test/core/router/app_router_test.dart
```

Coverage scoped (hanya file fitur):

```bash
flutter test --coverage test/features/<fitur>
awk '
/^SF:/ {file=substr($0,4); hit=(file ~ /lib\/features\/<fitur>\//); lf=0; lh=0}
hit && /^LF:/ {lf=substr($0,4)+0}
hit && /^LH:/ {lh=substr($0,4)+0}
/^end_of_record/ {if (hit && lf>0) printf "%s  %d/%d  %.1f%%\n", file, lh, lf, lh*100/lf}
' coverage/lcov.info
```

Definisi selesai:

- [ ] `flutter analyze` tanpa issue.
- [ ] Test fitur lulus semua.
- [ ] Test router lulus bila ada perubahan navigasi.
- [ ] Coverage file fitur sesuai target (default: 100% baris).
- [ ] Tidak ada teks/warna/radius hardcoded.
- [ ] Failure state punya retry dan pesan yang jelas.
- [ ] Aksi belum tersedia menampilkan "Segera hadir".

---

## 16. Template urutan kerja

```text
1. Kontrak halaman (data, aksi, state, key)
2. Entity + Equatable
3. Repository abstract + usecase
4. DataSource abstract + fake + RepositoryImpl
5. State enum + Cubit (load, retry)
6. Injeksi: DI (Pola A) atau default param (Pola B)
7. Strings + tema
8. Widget kecil → section
9. Halaman: BlocProvider + BlocBuilder switch
10. Route / branch navigasi
11. Test: data → cubit → halaman
12. Format → analyze → test scoped → coverage
```

---

## 17. Pitfall yang sering terjadi

| Gejala | Penyebab | Solusi |
|---|---|---|
| `Invalid constant value` pada `const Text(..., style: AppTextStyles.x)` | `AppTextStyles` adalah `static final`, bukan `const` | Hapus `const` pada widget `Text` |
| Test gagal "painting debug variable was changed" | `debugNetworkImageHttpClientProvider` di-reset lewat `addTearDown` | Reset dengan `try/finally` di dalam body test |
| Test menggantung / pending timer | Memakai `Future.delayed` untuk state loading | Gunakan `Completer` di repository palsu |
| `find.byKey` tidak menemukan elemen bawah | `ListView` lazy belum membangun item | Pakai `SingleChildScrollView` atau `scrollUntilVisible` |
| State success tetapi UI kosong | Lupa `..load()` saat membuat Cubit | Panggil `load()` di `create`/`initState` |
| UI tidak update setelah aksi | Memakai `context.read` di dalam `build` tanpa builder | Baca state lewat `BlocBuilder`/`BlocSelector` |
| Error mentah muncul di UI | Data layer melempar `Exception` | Bungkus jadi `Failure` dan tangkap `on Failure` |
| Halaman reload setiap rebuild | Cubit dibuat di `build()` tanpa provider stabil | Buat lewat `BlocProvider(create: ...)` |
| Teks berubah di dua tempat | String ditulis di widget | Pindahkan ke `<fitur>_strings.dart` |

---

## 18. Contoh nyata di repo

| Fitur | Pola injeksi | Titik menarik |
|---|---|---|
| `profile` | Default parameter (Pola B) | Pipeline lengkap entity → fake → cubit → page, 100% coverage |
| `tickets` | Default parameter (Pola B) | Cubit + filter/tab, loading/failure/retry |
| `home` | DI get_it (Pola A) | `HomeBloc` disediakan `MainShell` agar badge navigasi ikut membaca state |
| `auth` | DI + `BlocProvider.value` di root | State sesi global, redirect router lewat `AuthRouterNotifier` |

File acuan cepat:

- `lib/features/profile/` — contoh fitur baru paling lengkap.
- `lib/features/home/data/datasources/fake_home_data_source.dart` — pola fake
  dengan `static const content`.
- `lib/features/home/presentation/main_shell.dart` — state lintas tab.
- `lib/core/router/app_router.dart` — branch dan redirect.
- `lib/di/service_locator.dart` — composition root.
- `test/support/pump_app.dart` — helper test aplikasi.

---

## 19. Saatnya ganti data dummy ke API

Domain dan presentation **tidak berubah**. Yang dikerjakan:

1. Buat `Remote<Fitur>DataSource implements <Fitur>DataSource`.
2. Mapping JSON → entity di data layer.
3. Lempar `DataFailure` untuk status non-2xx / timeout.
4. Tukar implementasi:
   - Pola A: ubah satu baris di `service_locator.dart`.
   - Pola B: ubah default parameter di halaman (atau pindahkan ke DI).
5. Test data source baru dengan HTTP palsu; test cubit/halaman tetap memakai
   repository palsu yang sama.

Dengan urutan ini, halaman tidak pernah "menunggu backend": UI, state, dan
test sudah selesai lebih dulu, lalu sumber data ditukar tanpa menyentuh
tampilan.
