import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Batang progres pill (kuota terisi, hasil polling).
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.background = AppColors.lavender,
    this.height = 8,
  });

  /// Nilai 0–1; di luar rentang dipotong.
  final double value;
  final Color color;
  final Color background;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          color: color,
          backgroundColor: background,
          minHeight: height,
        ),
      ),
    );
  }
}
