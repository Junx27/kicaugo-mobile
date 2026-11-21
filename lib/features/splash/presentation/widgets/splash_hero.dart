import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/color_pill.dart';
import 'splash_mascot.dart';

/// Blok tengah splash: maskot, nama aplikasi, tagline, dan indikator.
class SplashHero extends StatelessWidget {
  const SplashHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SplashMascot(),
        const SizedBox(height: AppTheme.sectionSpacing),
        const _AppTitle(),
        const SizedBox(height: 4),
        Text(
          AppConstants.appTagline,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            ColorPill(width: 10, height: 6, color: AppColors.pink),
            ColorPill(width: 32, height: 8, color: AppColors.primary),
            ColorPill(width: 10, height: 6, color: AppColors.limeStrong),
          ],
        ),
      ],
    );
  }
}

/// Nama aplikasi dua warna dengan titik kuning di kanan atas.
class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: AppConstants.appNameLead,
            children: [
              TextSpan(
                text: AppConstants.appNameAccent,
                style: AppTextStyles.display.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          style: AppTextStyles.display,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 4, top: 6),
          child: ColorPill.dot(size: 10, color: AppColors.yellowStrong),
        ),
      ],
    );
  }
}
