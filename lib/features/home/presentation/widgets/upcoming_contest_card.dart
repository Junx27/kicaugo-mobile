import 'package:flutter/material.dart';

import '../../../../core/entities/ticket_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/tone_card.dart';
import '../../domain/entities/upcoming_contest.dart';
import '../home_strings.dart';

/// Kartu pink "Segera Berlangsung" dengan sisa tiket dan harga.
class UpcomingContestCard extends StatelessWidget {
  const UpcomingContestCard({super.key, required this.contest});

  final UpcomingContest contest;

  @override
  Widget build(BuildContext context) {
    final status = StatusChip.lookOf(TicketStatus.almostGone);
    return ToneCard(
      tone: AppTones.pink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: _RemainingBadge(count: contest.remainingTickets)),
              const Icon(
                Icons.timer_outlined,
                size: 18,
                color: AppColors.onPink,
              ),
            ],
          ),
          Text(
            contest.type,
            style: AppTextStyles.label.copyWith(color: AppColors.onPink),
          ),
          Text(
            contest.title,
            style: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            spacing: 4,
            children: [
              const Icon(Icons.schedule_rounded, size: 13),
              Flexible(
                child: Text(
                  contest.time,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Divider(color: AppColors.textPrimary.withValues(alpha: 0.08)),
          Text(HomeStrings.startingFrom, style: AppTextStyles.eyebrow),
          Text(
            contest.price,
            style: AppTextStyles.button.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          IconPill(
            icon: status.icon,
            iconColor: AppColors.onPink,
            label: status.label,
            backgroundAlpha: 0.8,
          ),
        ],
      ),
    );
  }
}

class _RemainingBadge extends StatelessWidget {
  const _RemainingBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.onPink,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        '${HomeStrings.remainingPrefix} $count ${HomeStrings.remainingSuffix}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.eyebrow.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
