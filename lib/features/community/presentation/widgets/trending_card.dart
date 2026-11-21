import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../../../../core/widgets/link_button.dart';
import '../../../../core/widgets/tone_card.dart';
import '../../domain/entities/trending_discussion.dart';
import '../community_strings.dart';
import 'number_format.dart';

/// Kartu kuning diskusi terhangat minggu ini.
class TrendingCard extends StatelessWidget {
  const TrendingCard({super.key, required this.discussion});

  final TrendingDiscussion discussion;

  @override
  Widget build(BuildContext context) {
    return ToneCard(
      tone: AppTones.yellow,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 8,
            children: [
              const Flexible(
                child: IconPill(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: AppColors.onPink,
                  label: CommunityStrings.trendingBadge,
                  backgroundAlpha: 0.8,
                ),
              ),
              Text(
                CommunityStrings.trendingSource,
                style: AppTextStyles.caption,
              ),
            ],
          ),
          Text(discussion.title, style: AppTextStyles.title),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${discussion.author}: ',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(text: discussion.quote),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Wrap(
                spacing: 10,
                children: [
                  _Stat(
                    icon: Icons.chat_bubble_rounded,
                    text:
                        '${formatThousands(discussion.replies)} '
                        '${CommunityStrings.repliesSuffix}',
                  ),
                  _Stat(
                    icon: Icons.visibility_rounded,
                    text: formatThousands(discussion.views),
                  ),
                  _Stat(
                    icon: Icons.favorite_rounded,
                    text: formatThousands(discussion.likes),
                    color: AppColors.onPink,
                  ),
                ],
              ),
              LinkButton(
                label: CommunityStrings.followDiscussion,
                trailingIcon: Icons.arrow_forward_rounded,
                style: AppTextStyles.label,
                onPressed: () => showComingSoon(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.text,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(icon, size: 16, color: color),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }
}
