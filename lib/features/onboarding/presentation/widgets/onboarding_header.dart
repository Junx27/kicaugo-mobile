import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/brand_badge.dart';
import '../onboarding_strings.dart';

/// Header onboarding: pill logo KicauGo dan tombol "Lewati".
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8,
      children: [
        const Flexible(child: BrandBadge()),
        TextButton(
          onPressed: onSkip,
          style: AppTheme.softPillButton(
            foreground: AppColors.primary,
            textStyle: AppTextStyles.button,
          ),
          child: const Text(OnboardingStrings.skip),
        ),
      ],
    );
  }
}
