import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Section timeline dengan badge jumlah.
class TicketHistoryTimelineGroup extends StatelessWidget {
  const TicketHistoryTimelineGroup({
    super.key,
    required this.icon,
    required this.title,
    required this.badge,
    required this.visible,
    required this.children,
  });

  final IconData icon;
  final String title;
  final String badge;
  final bool visible;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(icon, size: 18, color: AppColors.textSecondary),
                Text(title, style: AppTextStyles.label.copyWith(fontSize: 14)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppTheme.badgeRadius),
              ),
              child: Text(badge, style: AppTextStyles.caption),
            ),
          ],
        ),
        ...children,
      ],
    );
  }
}
