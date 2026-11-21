import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../onboarding_strings.dart';

/// Tombol aksi utama onboarding dan catatan kepercayaan di bawahnya.
class OnboardingCta extends StatelessWidget {
  const OnboardingCta({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        AppButton(
          key: const Key('onboarding_cta'),
          label: label,
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: onPressed,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            const Icon(
              Icons.shield_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            Flexible(
              child: Text(
                OnboardingStrings.trustNote,
                textAlign: TextAlign.center,
                style: AppTextStyles.label,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
