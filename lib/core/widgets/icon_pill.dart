import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

/// Pill kecil (default putih) berisi ikon opsional dan label tebal (badge/stiker/chip).
class IconPill extends StatelessWidget {
  const IconPill({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.iconColor = AppColors.primary,
    this.backgroundColor = AppColors.surface,
    this.backgroundAlpha = 1,
  });

  final String label;
  final IconData? icon;

  /// Ikon opsional di sisi kanan label (mis. panah pada tautan detail).
  final IconData? trailingIcon;
  final Color iconColor;
  final Color backgroundColor;

  /// Opasitas latar putih (mis. 0.85 untuk efek kaca di atas kartu pastel).
  final double backgroundAlpha;

  static const double _iconSize = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: backgroundAlpha),
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          if (icon != null) Icon(icon, size: _iconSize, color: iconColor),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.eyebrow.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (trailingIcon != null)
            Icon(trailingIcon, size: _iconSize, color: iconColor),
        ],
      ),
    );
  }
}
