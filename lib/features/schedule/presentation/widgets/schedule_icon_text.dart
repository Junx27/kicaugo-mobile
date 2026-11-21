import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Ikon kecil diikuti teks satu baris (tanggal, jam, lokasi).
class ScheduleIconText extends StatelessWidget {
  const ScheduleIconText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = AppColors.textSecondary,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(icon, size: 15, color: iconColor),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}
