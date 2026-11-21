import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../community_strings.dart';

/// Kolom pencarian komunitas (belum tersedia).
class CommunitySearchField extends StatelessWidget {
  const CommunitySearchField({super.key});

  static const double _height = 50;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.cardRadius);
    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      elevation: 1,
      shadowColor: AppColors.shadow,
      child: InkWell(
        borderRadius: radius,
        onTap: () => showComingSoon(context),
        child: SizedBox(
          height: _height,
          child: Row(
            spacing: 8,
            children: [
              const SizedBox(width: 6),
              const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              Expanded(
                child: Text(
                  CommunityStrings.searchHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
