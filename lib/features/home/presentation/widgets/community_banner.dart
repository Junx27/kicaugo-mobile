import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../home_strings.dart';

/// Banner ajakan bergabung ke grup komunitas.
class CommunityBanner extends StatelessWidget {
  const CommunityBanner({super.key});

  static const double _iconCircle = 44;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lavenderGlow,
      borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        onTap: () => showComingSoon(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: _iconCircle,
                height: _iconCircle,
                decoration: const BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.forum_rounded, color: AppColors.onLime),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HomeStrings.communityTitle,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      HomeStrings.communitySubtitle,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
