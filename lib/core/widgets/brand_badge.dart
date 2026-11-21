import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

/// Pill putih berisi logo maskot dan nama "Kicau" + "Go" (indigo).
class BrandBadge extends StatelessWidget {
  const BrandBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          SvgPicture.asset(
            AppConstants.mascotAsset,
            width: AppTheme.brandLogoSize,
            height: AppTheme.brandLogoSize,
          ),
          Flexible(
            child: Text.rich(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                text: AppConstants.appNameLead,
                children: [
                  TextSpan(
                    text: AppConstants.appNameAccent,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
