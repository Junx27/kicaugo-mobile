import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/top_bars.dart';
import '../home_strings.dart';

/// Bar atas Beranda: logo, lokasi, notifikasi, dan avatar profil.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return BrandTopBar(
      subtitle: Row(
        spacing: 2,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 13,
            color: AppColors.textSecondary,
          ),
          Flexible(
            child: Text(
              location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
      actions: [
        TopBarIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: HomeStrings.notificationsTooltip,
          showDot: true,
          onPressed: () => showComingSoon(context),
        ),
      ],
    );
  }
}
