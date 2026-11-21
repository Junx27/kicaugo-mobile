# Layout Playbook

Pola layout Flutter yang sering dipakai. Sesuaikan nama token (`AppColors`,
`AppTheme`, `AppTextStyles`) dengan tema repo yang sedang dikerjakan.

## 0. Prinsip yang perlu diterangkan ke user

1. **Constraint turun dari parent.** Parent menentukan lebar/tinggi maksimum;
   child memilih ukuran di dalam batas itu.
2. **`Expanded` hanya di dalam `Row`/`Column`/`Flex`.** Fungsinya membagi sisa
   ruang, bukan membuat ukuran tetap.
3. **`SingleChildScrollView` untuk halaman pendek/menengah.** Untuk daftar sangat
   panjang, gunakan `ListView.builder`/`SliverList` agar item dibangun lazy.
4. **Jangan menaruh `ListView` vertikal di dalam `Column` tanpa `Expanded`.**
   Tingginya tak terbatas dan memicu error layout.
5. **`IntrinsicHeight` mahal.** Pakai hanya untuk grid kecil yang jumlahnya tetap
   (mis. 2×2), bukan untuk daftar panjang.
6. **`const` bukan tujuan.** `const` hanya untuk nilai compile-time; callback dari
   instance tidak bisa dipaksa `const`.

## 1. Kerangka halaman: top bar fixed + body scroll

```dart
Scaffold(
  backgroundColor: AppColors.surfaceLavender,
  body: SafeArea(
    bottom: false,
    child: Column(
      children: [
        const _PageTopBar(), // fixed
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppTheme.sectionSpacing,
              children: const [
                _HeroSection(),
                _ContentSection(),
                _BottomCta(),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
)
```

Kenapa `Expanded` membungkus scroll view? Karena `Column` memberi tinggi tak
terbatas pada child non-flex; `Expanded` memberi batas tinggi layar sehingga
scroll bekerja.

## 2. Top bar dengan tombol kembali

```dart
Padding(
  padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
  child: Row(
    spacing: 4,
    children: [
      IconButton(
        key: const Key('page_back'),
        tooltip: 'Kembali',
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home);
          }
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      Expanded(
        child: Text(
          'Judul Halaman',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.title,
        ),
      ),
      const _StatusBadge(),
      const SizedBox(width: 4),
      const ProfileAvatarButton(),
    ],
  ),
)
```

Poin ajar:

- `Expanded` pada judul mencegah overflow saat teks panjang.
- `maxLines: 1` + `ellipsis` adalah pengaman wajib untuk judul dinamis.
- Tombol back harus punya fallback route; jangan asumsikan selalu ada riwayat.

## 3. Search field dengan aksi

```dart
Container(
  padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppTheme.pillRadius),
    boxShadow: AppTheme.softShadow,
  ),
  child: Row(
    spacing: 8,
    children: [
      const Icon(Icons.search_rounded, size: 22, color: AppColors.primary),
      Expanded(
        child: TextField(
          key: const Key('search_input'),
          controller: _controller,
          onChanged: widget.onChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: 'Cari sesuatu...',
          ),
        ),
      ),
      IconButton(
        key: const Key('search_filter'),
        onPressed: () => showComingSoon(context),
        icon: const Icon(Icons.tune_rounded, size: 18),
      ),
    ],
  ),
)
```

Poin ajar:

- `Expanded` membuat `TextField` mengisi sisa lebar.
- `isDense` + `contentPadding` mengatur tinggi visual tanpa mengubah tinggi row.
- `TextEditingController` dibuat di `initState` dan di-`dispose`.

## 4. Bento grid 2×2 (jumlah tetap)

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  spacing: AppTheme.itemSpacing,
  children: [
    for (var i = 0; i < actions.length; i += 2)
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppTheme.itemSpacing,
          children: [
            Expanded(child: _ActionCard(action: actions[i])),
            Expanded(
              child: i + 1 < actions.length
                  ? _ActionCard(action: actions[i + 1])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
  ],
)
```

Poin ajar:

- `Row + Expanded` lebih murah dan lebih mudah dikontrol daripada `GridView`
  untuk 4 kartu tetap.
- `IntrinsicHeight` membuat dua kartu satu baris sama tinggi.
- Cabang `SizedBox.shrink()` menangani jumlah ganjil; ini juga wajib dites.
- Untuk daftar dinamis puluhan item, ganti dengan `GridView.builder` atau
  `SliverGrid`.

## 5. Accordion FAQ

```dart
InkWell(
  key: Key('faq_${faq.id}'),
  onTap: onToggle,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(child: Text(faq.question)),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.expand_more_rounded),
            ),
          ],
        ),
        if (isExpanded)
          Container(
            key: Key('faq_answer_${faq.id}'),
            padding: const EdgeInsets.all(12),
            child: Text(faq.answer),
          ),
      ],
    ),
  ),
)
```

Poin ajar:

- State buka/tutup sebaiknya di Cubit, bukan `setState` lokal, agar mudah dites
  dan bisa menutup item lain saat pindah.
- `AnimatedRotation` hanya memutar ikon; tinggi konten berubah langsung.
- Jika ingin animasi tinggi, bungkus jawaban dengan `AnimatedSize` dan pastikan
  tidak dipakai di daftar sangat panjang.

## 6. Baris kontak

```dart
Row(
  spacing: 12,
  children: [
    Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(contact.icon, size: 20, color: AppColors.primary),
    ),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(contact.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(contact.role, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
    _CompactButton(label: contact.actionLabel),
  ],
)
```

Poin ajar:

- `Expanded` di tengah menyerap ruang, tombol tetap selebar kontennya.
- `maxLines` mencegah nama/role panjang merusak tinggi baris.
- Ukuran ikon 40px dengan padding 12 memberi target sentuh yang nyaman.

## 7. Kartu hero dengan glow

```dart
Container(
  clipBehavior: Clip.antiAlias,
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppTheme.panelRadius),
    boxShadow: AppTheme.softShadow,
  ),
  child: Stack(
    children: [
      const Positioned(
        right: -36,
        bottom: -36,
        child: GlowOrb(size: 144, color: AppColors.lavender, alpha: 0.7),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [/* isi kartu */],
        ),
      ),
    ],
  ),
)
```

Poin ajar:

- `clipBehavior: Clip.antiAlias` memotong glow agar tidak keluar kartu.
- `Positioned` negatif butuh parent `Stack` yang punya ukuran; jangan taruh di
  dalam `Column` tanpa batas.
- `GlowOrb` sebaiknya `IgnorePointer` agar tidak menangkap tap.

## 8. CTA bawah

```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppTheme.panelRadius),
    boxShadow: AppTheme.softShadow,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 16,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          const _IconBox(icon: Icons.headset_mic_rounded),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [Text(title), Text(body)],
            ),
          ),
        ],
      ),
      FilledButton.icon(
        key: const Key('cta_primary'),
        onPressed: onPressed,
        icon: const Icon(Icons.confirmation_number_rounded),
        label: const Text('Aksi Utama'),
      ),
    ],
  ),
)
```

Poin ajar:

- `crossAxisAlignment.stretch` membuat tombol selebar kartu.
- `CrossAxisAlignment.start` pada row membuat teks rata atas saat berdampingan
  dengan ikon.
- Jangan menaruh dua tombol besar bersebelahan tanpa `Expanded`; salah satu akan
  overflow di layar sempit.

## 9. Responsif

- `LayoutBuilder` untuk mengubah jumlah kolom:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final columns = constraints.maxWidth >= 700 ? 4 : 2;
    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      children: [...],
    );
  },
)
```

- `Wrap` untuk chip/tag yang jumlahnya dinamis.
- `ConstrainedBox(maxWidth: 720)` di tengah layar agar konten tidak melebar di
  tablet/desktop.
- `SafeArea` untuk notch dan home indicator; `resizeToAvoidBottomInset` untuk
  keyboard.

## 10. Anti-pattern yang harus disebutkan

| Anti-pattern | Gejala | Perbaikan |
|---|---|---|
| `ListView` di dalam `Column` tanpa `Expanded` | "unbounded height" | bungkus `Expanded` atau pakai `shrinkWrap` + `NeverScrollableScrollPhysics` (hanya untuk jumlah kecil) |
| `Expanded` di luar `Flex` | error parent data | pindahkan ke dalam `Row`/`Column` |
| `IntrinsicHeight` di daftar panjang | jank/berat | pakai tinggi tetap atau `GridView` |
| `Container(width: double.infinity)` di dalam `Row` | overflow | pakai `Expanded` |
| Hardcoded `Color(0xFF...)`, `EdgeInsets.all(17)` | tidak konsisten | pakai token tema |
| Teks panjang tanpa `maxLines`/`overflow` | overflow kuning-hitam | tambahkan `maxLines` + `ellipsis` |
| `const` dipaksa pada callback instance | `invalid_constant` | hapus `const` pada invocation |
| Nested scroll searah | scroll tidak predictable | satu scroll parent, child pakai `NeverScrollableScrollPhysics` |

## 11. Latihan kecil untuk user

Berikan satu per sesi, bukan semua sekaligus:

1. Ubah `spacing` section dari 24 → 16. Section mana yang paling terasa?
2. Hapus `Expanded` pada judul top bar. Apa yang terjadi saat judul panjang?
3. Ganti grid `Row + Expanded` menjadi `Wrap`. Bagaimana perilakunya di layar
   320px?
4. Tambahkan `maxLines: 2` pada deskripsi kartu. Di kartu mana teks terpotong?
5. Ganti `SingleChildScrollView` menjadi `ListView`. Apakah masih error? Kenapa?
