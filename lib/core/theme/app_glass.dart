import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Setelan liquid glass tunggal untuk seluruh aplikasi.
///
/// Nilainya mengikuti navigasi pill bawah agar top bar dan bottom bar pada
/// halaman detail maupun pemesanan terlihat identik.
abstract final class AppGlass {
  static const LiquidGlassSettings settings = LiquidGlassSettings(
    thickness: 20,
    blur: 8,
    refractiveIndex: 1.5,
    glassColor: Color(0x1AFFFFFF),
  );
}
