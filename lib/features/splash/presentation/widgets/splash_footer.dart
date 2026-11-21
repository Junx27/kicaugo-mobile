import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/color_pill.dart';
import '../../../../core/widgets/glass_pill.dart';

/// Bagian bawah splash: status pemuatan dan label versi.
class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  static const double _spinnerSize = 16;
  static const double _dotSize = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassPill(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              const SizedBox.square(
                dimension: _spinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                  backgroundColor: AppColors.lavender,
                ),
              ),
              Flexible(
                child: Text(
                  AppConstants.splashLoading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.itemSpacing),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(
              AppConstants.appVersionLabel,
              style: AppTextStyles.eyebrow.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                ColorPill.dot(size: _dotSize, color: AppColors.yellowStrong),
                ColorPill.dot(size: _dotSize, color: AppColors.pink),
                ColorPill.dot(size: _dotSize, color: AppColors.limeStrong),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
