import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glow_orb.dart';

/// Dua cahaya lavender buram di sudut kanan atas dan kiri bawah splash.
class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  static const double _offset = -64;

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: _offset,
          right: _offset,
          child: GlowOrb(size: 256, color: AppColors.lavenderGlow, alpha: 0.7),
        ),
        Positioned(
          bottom: _offset,
          left: _offset,
          child: GlowOrb(
            size: 288,
            color: AppColors.lavenderDeepGlow,
            alpha: 0.5,
          ),
        ),
      ],
    );
  }
}
