import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../theme/app_glass.dart';

/// Pill kaca mengambang di bawah halaman, dipakai bersama detail dan pemesanan.
class GlassPillBar extends StatelessWidget {
  const GlassPillBar({super.key, required this.child});

  /// Tinggi pill dan jari-jari sudutnya.
  static const double height = 60;
  static const double radius = height / 2;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: LiquidGlassLayer(
          settings: AppGlass.settings,
          child: LiquidGlass(
            shape: const LiquidRoundedSuperellipse(borderRadius: radius),
            child: SizedBox(height: height, child: child),
          ),
        ),
      ),
    );
  }
}
