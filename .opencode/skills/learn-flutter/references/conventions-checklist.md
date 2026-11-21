# Conventions Checklist

## Sebelum menulis layout

- [ ] Baca `AGENTS.md` / `CLAUDE.md` / `DEVELOPMENT.md`.
- [ ] Baca token tema: warna, spacing, radius, shadow, text style, tones.
- [ ] Baca class strings fitur terdekat.
- [ ] Baca widget bersama di `lib/core/widgets/`.
- [ ] Baca fitur paling mirip sebagai contoh struktur.
- [ ] Cek router dan pola navigasi yang dipakai.
- [ ] Cek apakah ada dependency yang dibutuhkan (mis. `url_launcher`); jika tidak
      ada, gunakan `showComingSoon`, jangan menambah package tanpa izin.

## Saat menulis layout

- [ ] Path file sesuai struktur fitur (`domain`, `data`, `presentation`).
- [ ] Nama file `snake_case.dart`; class `PascalCase`.
- [ ] Tidak ada warna hardcoded; pakai `AppColors`/theme.
- [ ] Tidak ada spacing/radius hardcoded; pakai `AppTheme`.
- [ ] Tidak ada teks hardcoded di widget; pakai strings.
- [ ] Maksimal 3 tone pastel per layar.
- [ ] Aksi belum tersedia memakai `showComingSoon`.
- [ ] Setiap elemen interaktif yang akan dites punya `Key` unik.
- [ ] Teks dinamis memakai `maxLines` + `TextOverflow.ellipsis`.
- [ ] `Expanded`/`Flexible` dipakai tepat, tidak di luar `Row`/`Column`.
- [ ] Tidak ada `ListView` vertikal di dalam `Column` tanpa `Expanded`.
- [ ] Tidak memaksa `const` pada callback runtime.
- [ ] `TextEditingController`/`AnimationController` di-dispose.
- [ ] `SafeArea` dan `resizeToAvoidBottomInset` dipertimbangkan.
- [ ] Aksesibilitas: tooltip pada icon button, target sentuh memadai.

## Setelah user paste

- [ ] `dart format` file yang berubah.
- [ ] `flutter analyze` scope fitur.
- [ ] Jika ada error, jelaskan penyebab lalu patch minimal.
- [ ] Jangan refactor file lain tanpa izin.
- [ ] Tawarkan pembuatan test.

## Sebelum menulis test

- [ ] Baca kode aktual, bukan panduan lama.
- [ ] Catat semua `Key`, teks, route, dan aksi.
- [ ] Baca test terdekat untuk meniru pola.
- [ ] Tentukan scope: hanya `lib/features/<fitur>/`.
- [ ] Siapkan fakes: data contoh, repository gagal/delay, completer.

## Saat menulis test

- [ ] Struktur folder test meniru struktur fitur.
- [ ] Data test: fake datasource, repository, usecase, entity equality.
- [ ] Cubit test: loading, success, failure, getter, search, toggle.
- [ ] Page test: loading, success, failure/retry, search, accordion, aksi.
- [ ] Widget test: cabang visual yang tidak muncul di page.
- [ ] Router test: entry point fitur dari layar asal.
- [ ] Viewport tinggi + `addTearDown(tester.view.reset)`.
- [ ] `ensureVisible` sebelum tap elemen bawah.
- [ ] Tidak memakai `pumpAndSettle` pada animasi berulang.
- [ ] Test navigasi memakai `GoRouter` minimal.
- [ ] Tidak ada production code yang diubah demi test.

## Sebelum menyatakan selesai

- [ ] `dart format` → 0 changed (atau sudah dijalankan).
- [ ] `flutter analyze` scope test → no issues.
- [ ] `flutter test` scope fitur → all tests passed (sertakan jumlah).
- [ ] `flutter test --coverage` → parse hanya file fitur.
- [ ] Laporkan `LH/LF` per file + total.
- [ ] Sebutkan gap jika ada, beserta alasan.
- [ ] Sebutkan temuan lama di luar scope tanpa memperbaikinya.
