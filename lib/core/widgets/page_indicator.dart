import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Indikator halaman: titik untuk halaman lain, pill memanjang untuk aktif.
class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key, required this.count, required this.current});

  final int count;
  final int current;

  static const double _dotSize = 8;
  static const double _activeWidth = 28;
  static const Duration _duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        for (var index = 0; index < count; index++)
          AnimatedContainer(
            duration: _duration,
            width: index == current ? _activeWidth : _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: index == current ? AppColors.primary : AppColors.lavender,
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
            ),
          ),
      ],
    );
  }
}
