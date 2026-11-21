import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ikon plus dengan ketebalan garis yang bisa diatur.
///
/// Material Icons hanya menyediakan `add` dengan ketebalan bawaan, jadi plus
/// digambar langsung dengan dua garis bersudut bulat agar lebih tebal.
class ThickPlusIcon extends StatelessWidget {
  const ThickPlusIcon({
    super.key,
    this.size = 24,
    this.strokeWidth = 3,
    this.color = AppColors.textSecondary,
  });

  final double size;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _PlusPainter(color: color, strokeWidth: strokeWidth),
  );
}

class _PlusPainter extends CustomPainter {
  const _PlusPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = size.center(Offset.zero);
    final half = size.width * 0.35;

    canvas.drawLine(
      Offset(center.dx - half, center.dy),
      Offset(center.dx + half, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - half),
      Offset(center.dx, center.dy + half),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlusPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
