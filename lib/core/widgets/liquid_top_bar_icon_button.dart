import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../theme/app_colors.dart';

/// Tombol ikon bulat dengan latar kaca (blur + translusen) untuk top bar.
///
/// Widget ini harus berada di bawah `LiquidGlassLayer` yang memakai
/// `AppGlass.settings` agar seluruh ikon berbagi satu layer kaca.
class LiquidTopBarIconButton extends StatelessWidget {
  /// Diameter tombol, juga dipakai sebagai tinggi judul kaca di top bar.
  static const double size = 44;

  const LiquidTopBarIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.iconSize = 20,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      shape: const LiquidOval(),
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, size: iconSize, color: AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
