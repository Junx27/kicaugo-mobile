import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../../../../core/widgets/tone_card.dart';
import '../../domain/entities/community_poll.dart';
import '../community_strings.dart';
import 'number_format.dart';

/// Hasil polling yang sudah dihitung ulang termasuk suara pengguna.
typedef PollTally = ({int? choice, int total, int Function(int) percentOf});

/// Kartu lime polling; mengetuk pilihan memberi/mengganti suara.
class PollCard extends StatelessWidget {
  const PollCard({
    super.key,
    required this.poll,
    required this.tally,
    required this.onVote,
  });

  final CommunityPoll poll;
  final PollTally tally;
  final ValueChanged<int> onVote;

  @override
  Widget build(BuildContext context) {
    return ToneCard(
      tone: AppTones.lime,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Row(
            spacing: 8,
            children: [
              const Flexible(
                child: IconPill(
                  icon: Icons.poll_rounded,
                  iconColor: AppColors.onLime,
                  label: CommunityStrings.pollBadge,
                  backgroundAlpha: 0.8,
                ),
              ),
              const Spacer(),
              const Icon(Icons.timer_outlined, size: 14),
              Text(poll.closesIn, style: AppTextStyles.caption),
            ],
          ),
          Text(poll.question, style: AppTextStyles.title),
          for (var index = 0; index < poll.options.length; index++)
            _PollOptionTile(
              label: poll.options[index].label,
              percent: tally.percentOf(index),
              selected: tally.choice == index,
              onTap: () => onVote(index),
            ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            children: [
              Text(
                '${CommunityStrings.votesPrefix} ${formatThousands(tally.total)} '
                '${CommunityStrings.votesSuffix}',
                style: AppTextStyles.caption,
              ),
              Text(
                tally.choice == null
                    ? CommunityStrings.pollHint
                    : CommunityStrings.pollSaved,
                style: AppTextStyles.caption.copyWith(color: AppColors.onLime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PollOptionTile extends StatelessWidget {
  const _PollOptionTile({
    required this.label,
    required this.percent,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int percent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.cardRadius);
    final accent = selected ? AppColors.onLime : AppColors.textSecondary;
    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent / 100,
                child: ColoredBox(
                  color: selected
                      ? AppColors.limeStrong.withValues(alpha: 0.5)
                      : AppColors.lavender.withValues(alpha: 0.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18,
                    color: accent,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: AppTextStyles.label.copyWith(color: accent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
