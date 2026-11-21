import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../onboarding_strings.dart';

/// Dua tile statistik kecil: garansi dan komunitas.
class StatTiles extends StatelessWidget {
  const StatTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 8,
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.verified_rounded,
            iconColor: AppColors.primary,
            label: OnboardingStrings.statGuaranteeLabel,
            value: OnboardingStrings.statGuaranteeValue,
          ),
        ),
        Expanded(
          child: _StatTile(
            icon: Icons.groups_rounded,
            iconColor: AppColors.textSecondary,
            label: OnboardingStrings.statCommunityLabel,
            value: OnboardingStrings.statCommunityValue,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: AppTheme.iconBoxSize,
            height: AppTheme.iconBoxSize,
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
            ),
            child: Icon(icon, color: iconColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.eyebrow),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
