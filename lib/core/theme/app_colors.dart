import 'package:flutter/material.dart';

/// Palet warna KicauGo: indigo sebagai aksi utama, pastel sebagai aksen.
///
/// Seluruh nilai warna aplikasi hanya didefinisikan di file ini. Widget tidak
/// boleh menulis kode hex sendiri agar tema mudah diganti dan tidak ada
/// literal berulang (Sonar S1192). Maksimal tiga warna pastel per layar.
abstract final class AppColors {
  /// Indigo: tombol, tab aktif, tautan, state terpilih.
  static const Color primary = Color(0xFF4B44B8);

  /// Indigo saat ditekan.
  static const Color primaryPressed = Color(0xFF373294);

  /// Primary dengan opasitas 12% untuk indikator navbar.
  static const Color primaryIndicator = Color(0x1F4B44B8);

  /// Cincin tipis primary 20% untuk penanda terpilih.
  static const Color primaryRing = Color(0x334B44B8);

  /// Cincin fokus input: primary 40%.
  static const Color primaryFocus = Color(0x664B44B8);

  /// Latar halaman. Sengaja sedikit hangat agar putih murni [surface]
  /// punya jeda visual; [surface] tetap putih untuk border rute di peta.
  static const Color background = Color(0xFFFBFAF8);

  /// Permukaan kartu, input, dan navbar.
  static const Color surface = Color(0xFFFFFFFF);

  /// Permukaan lavender sangat terang.
  static const Color surfaceLavender = Color(0xFFF7F7FD);

  /// Warna teks utama.
  static const Color textPrimary = Color(0xFF15122B);

  /// Warna teks sekunder, caption, dan ikon non-aktif.
  static const Color textSecondary = Color(0xFF5F5C73);

  /// Garis tepi kartu, input, dan pemisah.
  static const Color border = Color(0xFFE8E8F2);

  /// Bayangan lembut berbasis warna teks utama (8%).
  static const Color shadow = Color(0x1415122B);

  /// Status gagal (kontras aman untuk teks kecil di atas putih).
  static const Color error = Color(0xFFD42A58);

  /// Isi input dan tombol sekunder lembut (lavender sangat muda).
  static const Color inputFill = lavenderTintStart;

  /// Lavender lembut: chip, empty state, garis aksen.
  static const Color lavender = Color(0xFFE9E5FF);

  /// Lavender untuk cahaya latar (orb blur).
  static const Color lavenderGlow = Color(0xFFF0EBFF);

  /// Lavender keindigoan untuk cahaya latar (orb blur).
  static const Color lavenderDeepGlow = Color(0xFFE2DFFF);

  /// Awal gradient kartu maskot.
  static const Color lavenderTintStart = Color(0xFFF6F1FF);

  /// Akhir gradient kartu maskot.
  static const Color lavenderTintEnd = Color(0xFFEDE8FF);

  /// Kuning hangat (awal gradient).
  static const Color yellow = Color(0xFFFDE68A);

  /// Kuning hangat (akhir gradient, titik aksen).
  static const Color yellowStrong = Color(0xFFFBD34D);

  /// Ikon/teks di atas kuning.
  static const Color onYellow = Color(0xFFB45309);

  /// Pink (awal gradient).
  static const Color pink = Color(0xFFFFC2CF);

  /// Pink (akhir gradient, teks gelap).
  static const Color pinkStrong = Color(0xFFF9889F);

  /// Ikon/teks di atas pink.
  static const Color onPink = Color(0xFFD42A58);

  /// Hijau sage lembut (awal gradient).
  static const Color lime = Color(0xFFE8F0D6);

  /// Hijau sage (akhir gradient, garis tepi chip).
  static const Color limeStrong = Color(0xFFCFDFA9);

  /// Ikon/teks di atas lime.
  static const Color onLime = Color(0xFF4A5A38);

  /// Biru periwinkle (awal gradient).
  static const Color periwinkle = Color(0xFFDCE6FB);

  /// Biru periwinkle (akhir gradient).
  static const Color periwinkleStrong = Color(0xFFC9D8F7);

  /// Biru tegas untuk garis rute dan titik lokasi pengguna di peta.
  static const Color blueStrong = Color(0xFF2563EB);
}
