import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Bentuk pill/titik berwarna polos untuk indikator dan aksen kecil.
class ColorPill extends StatelessWidget {
  const ColorPill({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  /// Titik bulat dengan diameter [size].
  const ColorPill.dot({super.key, required double size, required this.color})
    : width = size,
      height = size;

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        ),
      ),
    );
  }
}
