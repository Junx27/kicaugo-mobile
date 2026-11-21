import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glow_orb.dart';
import '../../../../core/widgets/pulse_badge.dart';

/// Banner sambutan lavender: eyebrow berdenyut, judul, deskripsi, dan chip.
class AuthHero extends StatelessWidget {
  const AuthHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.chips,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -24,
            bottom: -32,
            child: GlowOrb(
              size: 128,
              color: AppColors.primary,
              alpha: 0.1,
              blurSigma: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                PulseBadge(
                  label: eyebrow,
                  backgroundColor: AppColors.surface.withValues(alpha: 0.8),
                ),
                Text(title, style: AppTextStyles.headline),
                Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(spacing: 8, runSpacing: 8, children: chips),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
