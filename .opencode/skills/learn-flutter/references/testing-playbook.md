# Testing Playbook

Resep test untuk fitur Flutter dengan pola feature-first (domain → data →
presentation). Semua contoh memakai nama generik; sesuaikan dengan fitur yang
sedang dikerjakan.

## 0. Urutan kerja

1. Baca kode aktual (bukan panduan lama).
2. Buat `*_fakes.dart`.
3. Tulis data test.
4. Tulis cubit/state test.
5. Tulis page + widget test.
6. Tambah test router jika ada navigasi baru.
7. Format → analyze → test → coverage scoped.
8. Tutup gap, lalu laporkan bukti.

## 1. Fakes

```dart
import 'dart:async';

import 'package:<app>/core/error/failure.dart';
import 'package:<app>/features/<fitur>/data/datasources/fake_<fitur>_data_source.dart';
import 'package:<app>/features/<fitur>/data/repositories/<fitur>_repository_impl.dart';
import 'package:<app>/features/<fitur>/domain/entities/<fitur>_content.dart';
import 'package:<app>/features/<fitur>/domain/repositories/<fitur>_repository.dart';
import 'package:<app>/features/<fitur>/domain/usecases/get_<fitur>_content.dart';

const String <fitur>Failure = 'Gagal memuat <fitur>';
const <Fitur>Content sample<Fitur> = Fake<Fitur>DataSource.content;

const Get<Fitur>Content instant<Fitur> = Get<Fitur>Content(
  <Fitur>RepositoryImpl(Fake<Fitur>DataSource(delay: Duration.zero)),
);

class Fake<Fitur>Repository implements <Fitur>Repository {
  Fake<Fitur>Repository({
    this.content = sample<Fitur>,
    this.delay = Duration.zero,
    this.failuresRemaining = 0,
  });

  final <Fitur>Content content;
  final Duration delay;
  int failuresRemaining;
  int fetchCalls = 0;

  @override
  Future<<Fitur>Content> fetch<Fitur>Content() async {
    fetchCalls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure(<fitur>Failure);
    }
    return content;
  }
}

class Completer<Fitur>Repository implements <Fitur>Repository {
  Completer<Fitur>Repository(this.completer);

  final Completer<<Fitur>Content> completer;

  @override
  Future<<Fitur>Content> fetch<Fitur>Content() => completer.future;
}
```

Kenapa data contoh diambil dari fake datasource produksi? Agar test widget,
cubit, dan data memakai sumber yang sama; tidak ada duplikasi data demo.

## 2. Data test

```dart
test('fake data source mengembalikan konten lengkap', () async {
  const dataSource = Fake<Fitur>DataSource(delay: Duration.zero);
  final content = await dataSource.fetch<Fitur>Content();

  expect(content, same(Fake<Fitur>DataSource.content));
  expect(content.items, hasLength(4));
});

test('fake data source menunggu delay', () async {
  const dataSource = Fake<Fitur>DataSource(delay: Duration(milliseconds: 1));
  final content = await dataSource.fetch<Fitur>Content();

  expect(content.title, isNotEmpty);
});

test('repository meneruskan data source', () async {
  const repository = <Fitur>RepositoryImpl(
    Fake<Fitur>DataSource(delay: Duration.zero),
  );

  final content = await repository.fetch<Fitur>Content();

  expect(content.items.last.name, isNotEmpty);
});

test('usecase memanggil repository', () async {
  final repository = Fake<Fitur>Repository();
  final content = await Get<Fitur>Content(repository)();

  expect(repository.fetchCalls, 1);
  expect(content, same(sample<Fitur>));
});

test('entity membandingkan seluruh properti', () {
  final item = sample<Fitur>.items.first;

  expect(
    item,
    Item(
      id: item.id,
      title: item.title,
      description: item.description,
    ),
  );
  expect(
    sample<Fitur>,
    <Fitur>Content(items: sample<Fitur>.items),
  );
});
```

Test entity equality penting: jika ada properti baru yang lupa dimasukkan ke
`props`, test ini akan gagal.

## 3. Cubit test

```dart
blocTest<Cubit, State>(
  'memuat konten lalu success',
  build: buildCubit,
  act: (cubit) => cubit.load(),
  expect: () => const [
    State(status: Status.loading),
    State(status: Status.success, content: sampleContent),
  ],
);

blocTest<Cubit, State>(
  'gagal memuat menyimpan pesan',
  build: () => buildCubit(FakeRepository(failuresRemaining: 1)),
  act: (cubit) => cubit.load(),
  expect: () => const [
    State(status: Status.loading),
    State(status: Status.failure, message: failureMessage),
  ],
);
```

Untuk getter turunan (mis. `visibleItems`), uji langsung tanpa widget:

```dart
test('pencarian memfilter pertanyaan dan jawaban', () async {
  final cubit = buildCubit();
  addTearDown(cubit.close);
  await cubit.load();

  cubit.search('kata-di-jawaban');
  expect(cubit.state.visibleItems.single.id, 'target');

  cubit.search('tidak-ada');
  expect(cubit.state.visibleItems, isEmpty);
});
```

Kasus yang perlu dicakup:

- query kosong → semua item
- query dengan spasi di awal/akhir → trim
- huruf besar/kecil → case-insensitive
- kata kunci hanya ada di jawaban/description
- pencarian baru menutup item yang sedang terbuka
- toggle buka → pindah → tutup

## 4. Page test harness

```dart
const Size _viewport = Size(420, 4200);
const Duration _frame = Duration(milliseconds: 2);

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(_frame);
}

Future<void> _pumpPage(
  WidgetTester tester, {
  GetContent getContent = instantContent,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: FeaturePage(getContent: getContent),
    ),
  );
  await _settle(tester);
}
```

Viewport tinggi membuat semua section dibangun. Tetap gunakan `ensureVisible`
sebelum mengetuk elemen di bawah fold.

### Loading

```dart
final completer = Completer<Content>();
await _pumpPage(
  tester,
  getContent: GetContent(CompleterRepository(completer)),
);

expect(find.byType(CircularProgressIndicator), findsOneWidget);

completer.complete(sampleContent);
await _settle(tester);

expect(find.byType(CircularProgressIndicator), findsNothing);
expect(find.text('Judul'), findsOneWidget);
```

### Failure + retry

```dart
await _pumpPage(
  tester,
  getContent: GetContent(FakeRepository(failuresRemaining: 1)),
);

expect(find.text(failureMessage), findsOneWidget);

await tester.tap(find.text(AppConstants.retryLabel));
await _settle(tester);

expect(find.text(failureMessage), findsNothing);
expect(find.text('Judul'), findsOneWidget);
```

### Search + empty state

```dart
await tester.enterText(find.byKey(const Key('search_input')), 'kata');
await tester.pump();

expect(find.text('Item yang cocok'), findsOneWidget);
expect(find.byKey(const Key('empty_state')), findsNothing);

await tester.enterText(find.byKey(const Key('search_input')), 'tidak-ada');
await tester.pump();

expect(find.byKey(const Key('empty_state')), findsOneWidget);
```

### Accordion

```dart
final tile = find.byKey(const Key('faq_offline'));

await tester.ensureVisible(tile);
await tester.tap(tile);
await tester.pump();
expect(find.byKey(const Key('faq_answer_offline')), findsOneWidget);

await tester.tap(tile);
await tester.pump();
expect(find.byKey(const Key('faq_answer_offline')), findsNothing);
```

### Snackbar / aksi belum tersedia

```dart
final button = find.byKey(const Key('action_chat'));

await tester.ensureVisible(button);
await tester.tap(button);
await tester.pump();

expect(find.text(AppConstants.comingSoon), findsOneWidget);
```

Loop semua key yang serupa agar setiap cabang visual/aksi tercakup:

```dart
for (final id in ['chat', 'refund', 'appeal', 'payment']) {
  testWidgets('aksi $id menampilkan segera hadir', (tester) async {
    await _pumpPage(tester);
    final finder = find.byKey(Key('action_$id'));

    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pump();

    expect(find.text(AppConstants.comingSoon), findsOneWidget);
  });
}
```

## 5. Navigasi halaman

### `MaterialApp` vs `GoRouter`

- `MaterialApp(home: Page())` cukup untuk konten dan interaksi yang tidak
  memanggil `context.push/pop/go`.
- Jika halaman memakai back/avatar, gunakan router minimal.

```dart
final router = GoRouter(
  initialLocation: AppRoutes.helpCenter,
  routes: [
    GoRoute(
      path: AppRoutes.helpCenter,
      builder: (context, state) => FeaturePage(getContent: instantContent),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const Scaffold(body: Text('profile-marker')),
    ),
  ],
);
addTearDown(router.dispose);

await tester.pumpWidget(
  MaterialApp.router(theme: AppTheme.light, routerConfig: router),
);
```

Jika halaman memanggil `context.push` tetapi test memakai `MaterialApp` biasa,
error-nya:

```text
No GoRouter found in context
```

Solusi: bungkus dengan `GoRouter`, atau jangan tes navigasi di file itu.

### Back dengan riwayat vs tanpa riwayat

```dart
// Dengan riwayat: mulai dari /start, push halaman, lalu tap back.
await tester.tap(find.byKey(const Key('open_page')));
await _pumpNavigation(tester);
await tester.tap(find.byKey(const Key('page_back')));
await _pumpNavigation(tester);
expect(find.text('start-marker'), findsOneWidget);

// Tanpa riwayat: initialLocation langsung ke halaman.
await tester.tap(find.byKey(const Key('page_back')));
await _pumpNavigation(tester);
expect(find.text('profile-marker'), findsOneWidget);
```

Gunakan durasi transisi yang cukup (mis. 600ms dua kali), jangan hanya satu
`pump`, agar halaman lama benar-benar keluar dari tree.

## 6. Widget branch test

Untuk cabang yang tidak muncul di page (mis. jumlah ganjil, tombol tanpa ikon):

```dart
testWidgets('quick actions berjumlah ganjil tetap tersusun', (tester) async {
  final actions = sampleContent.items.take(3).toList();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: SingleChildScrollView(
          child: QuickActions(actions: actions),
        ),
      ),
    ),
  );

  expect(find.text('3 Modul Aktif'), findsOneWidget);
  expect(tester.takeException(), isNull);
});
```

## 7. Router integration test

Tambahkan di file test router yang sudah ada, bukan di file page:

```dart
testWidgets('menu bantuan di Profil membuka Pusat Bantuan', (tester) async {
  await pumpApp(tester);
  await login(tester);
  await pumpNavigation(tester);

  await tester.tap(find.text(navProfile).last);
  await pumpNavigation(tester);
  await tapVisible(tester, find.byKey(const Key('profile_help')));

  expect(find.byType(HelpCenterPage), findsOneWidget);
  expect(find.text(HelpCenterStrings.heading), findsOneWidget);
});
```

Manfaat: memverifikasi wiring `onTap → context.push → route → page`, bukan hanya
halaman tujuan secara terisolasi.

## 8. Coverage scoped

```bash
flutter test --coverage test/features/<fitur>
```

Parse hanya file fitur:

```bash
python3 - <<'PY'
import re
from pathlib import Path

records = Path('coverage/lcov.info').read_text().split('end_of_record')
total_lf = total_lh = 0
for rec in records:
    match = re.search(r'^SF:(.+)$', rec, re.M)
    if not match or 'lib/features/<fitur>/' not in match.group(1):
        continue
    lf = int(re.search(r'^LF:(\d+)$', rec, re.M).group(1))
    lh = int(re.search(r'^LH:(\d+)$', rec, re.M).group(1))
    total_lf += lf
    total_lh += lh
    print(f'{match.group(1)}  {lh}/{lf}')
print(f'TOTAL {total_lh}/{total_lf}')
PY
```

Catatan Dart/Flutter:

- lcov dari `flutter test` umumnya **tidak menulis `FNF/FNDA`**, jadi metrik
  method tidak tersedia. Laporkan line coverage dan sebutkan keterbatasan ini.
- File abstrak (repository/data source contract) tidak muncul karena tidak punya
  baris eksekusi.
- Jangan mengejar 100% dengan mengubah production code. Jika ada baris defensive
  yang benar-benar tidak terjangkau lewat perilaku publik, laporkan sebagai gap.

## 9. Jebakan umum

| Gejala | Penyebab | Solusi |
|---|---|---|
| `No GoRouter found in context` | page memakai `context.push/pop/go`, test pakai `MaterialApp` | pakai `MaterialApp.router` + `GoRouter` minimal |
| `pumpAndSettle` timeout | animasi berulang (splash, shimmer, progress) | `pump(duration)` eksplisit |
| Elemen tidak ditemukan | di luar viewport / belum di-scroll | viewport tinggi + `ensureVisible` |
| `Found 2 widgets with text ...` | teks sama di dua tempat | pakai `Key`, atau `.first`/`.last` secara sadar |
| `invalid_constant` | `const` pada callback dari instance field | hapus `const` pada invocation |
| Test loading tidak pernah success | `Completer` belum di-`complete` | selesaikan completer lalu pump |
| SnackBar tidak muncul | belum pump setelah tap | `await tester.pump()` setelah tap |
| Halaman lama masih ada setelah pop | transisi belum selesai | pump dua kali durasi transisi |
| Coverage file fitur 0% | test tidak meng-import file itu | pastikan page/widget benar-benar dirender |
| `setState() called after dispose` | controller/timer tidak dibersihkan | dispose di `State.dispose` |

## 10. Checklist hasil test

- [ ] Semua layer punya test: data, entity, cubit/state, widget, page.
- [ ] Loading, success, failure, retry tercakup.
- [ ] Semua tombol/aksi utama dites (minimal satu test per `Key`).
- [ ] Accordion buka/pindah/tutup dites.
- [ ] Search: pertanyaan, jawaban, kosong dites.
- [ ] Back dengan/tanpa riwayat dites jika ada.
- [ ] Route baru dites dari layar asal.
- [ ] `dart format` bersih.
- [ ] `flutter analyze` scope test bersih.
- [ ] `flutter test` scope fitur hijau.
- [ ] Coverage line 100% untuk `lib/features/<fitur>/` atau gap dilaporkan.
