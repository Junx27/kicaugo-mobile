import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Avatar bulat/kotak berisi inisial, pengganti foto atau logo.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 44,
    this.color = AppColors.primary,
    this.foreground = AppColors.surface,
    this.radius,
  });

  final String initials;
  final double size;
  final Color color;
  final Color foreground;

  /// Radius sudut; `null` berarti lingkaran penuh.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radius == null ? null : BorderRadius.circular(radius!),
      ),
      child: Text(
        initials,
        maxLines: 1,
        style: AppTextStyles.label.copyWith(
          color: foreground,
          fontSize: size * 0.3,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
