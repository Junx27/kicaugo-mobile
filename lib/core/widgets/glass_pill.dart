import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../theme/app_theme.dart';

/// Container pill/kartu dengan efek kaca cair (liquid glass):
/// LiquidGlassLayer + LiquidGlass (LiquidRoundedSuperellipse).
class GlassPill extends StatelessWidget {
  const GlassPill({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma = 8,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppTheme.pillRadius);
    return LiquidGlassLayer(
      settings: LiquidGlassSettings(
        thickness: 20,
        blur: blurSigma,
        refractiveIndex: 1.5,
        glassColor: const Color(0x1AFFFFFF),
      ),
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: radius.topLeft.x),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
