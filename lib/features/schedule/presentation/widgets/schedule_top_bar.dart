import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/top_bars.dart';
import '../../domain/entities/schedule_content.dart';
import '../schedule_strings.dart';

/// Bar atas Jadwal: brand + LIVE, lokasi dan jumlah arena, notifikasi.
class ScheduleTopBar extends StatelessWidget {
  const ScheduleTopBar({super.key, required this.summary});

  final ScheduleSummary summary;

  @override
  Widget build(BuildContext context) {
    return BrandTopBar(
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.lime,
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          border: Border.all(color: AppColors.limeStrong),
        ),
        child: Text(
          ScheduleStrings.live,
          style: AppTextStyles.eyebrow.copyWith(
            color: AppColors.onLime,
            fontWeight: FontWeight.w800,
            fontSize: 9,
          ),
        ),
      ),
      subtitle: Row(
        spacing: 4,
        children: [
          const Icon(Icons.near_me_rounded, size: 13, color: AppColors.onLime),
          Flexible(
            child: Text(
              '${summary.location} • ${summary.nearbyArenas} '
              '${ScheduleStrings.nearbyArenasSuffix}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TopBarIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: ScheduleStrings.notificationsTooltip,
          showDot: true,
          onPressed: () => showComingSoon(context),
        ),
      ],
    );
  }
}
