import 'dart:ui';

import 'package:flutter/material.dart';

/// Lingkaran berwarna yang diburamkan untuk cahaya latar dekoratif.
class GlowOrb extends StatelessWidget {
  const GlowOrb({
    super.key,
    required this.size,
    required this.color,
    required this.alpha,
    this.blurSigma = 32,
  });

  final double size;
  final Color color;
  final double alpha;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: alpha),
          ),
        ),
      ),
    );
  }
}
