import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../home_strings.dart';

/// Kolom pencarian (belum tersedia) dengan tombol filter.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  static const double _height = 48;
  static const double _filterSize = 36;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const StadiumBorder(),
      shadowColor: AppColors.shadow,
      elevation: 2,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => showComingSoon(context),
        child: SizedBox(
          height: _height,
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  HomeStrings.searchHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                tooltip: HomeStrings.filterTooltip,
                onPressed: () => showComingSoon(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.lavenderGlow,
                  fixedSize: const Size.square(_filterSize),
                  minimumSize: const Size.square(_filterSize),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(
                  Icons.tune_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
