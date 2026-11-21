import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/tone_card.dart';
import '../../domain/entities/home_stats.dart';
import '../home_strings.dart';

/// Kartu lime "Statistik Kicau".
class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({super.key, required this.stats});

  final HomeStats stats;

  static const double _iconCircle = 32;

  @override
  Widget build(BuildContext context) {
    return ToneCard(
      tone: AppTones.lime,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 4,
            children: [
              Container(
                width: _iconCircle,
                height: _iconCircle,
                decoration: BoxDecoration(
                  color: AppColors.onLime.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 18,
                  color: AppColors.onLime,
                ),
              ),
              Flexible(child: _Badge(label: stats.badge)),
            ],
          ),
          Text(
            HomeStrings.statsEyebrow,
            style: AppTextStyles.eyebrow.copyWith(color: AppColors.onLime),
          ),
          Text(
            stats.headline,
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            stats.note,
            style: AppTextStyles.caption.copyWith(color: AppColors.onLime),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
            ),
            child: Row(
              spacing: 6,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  size: 15,
                  color: AppColors.onLime,
                ),
                Expanded(
                  child: Text(
                    stats.securityNote,
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.onLime,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.onLime,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.eyebrow.copyWith(
          color: AppColors.surface,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
