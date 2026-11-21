import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/link_button.dart';
import '../../domain/entities/bird_club.dart';
import '../community_strings.dart';
import 'number_format.dart';

/// Bagian lavender "Bird Club Populer" dengan kartu klub mendatar.
class ClubSection extends StatelessWidget {
  const ClubSection({
    super.key,
    required this.clubs,
    required this.isJoined,
    required this.memberCount,
    required this.onToggleJoin,
  });

  final List<BirdClub> clubs;
  final bool Function(BirdClub club) isJoined;
  final int Function(BirdClub club) memberCount;
  final ValueChanged<BirdClub> onToggleJoin;

  static const double _listHeight = 212;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.lavenderGlow,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _Header(),
          ),
          SizedBox(
            height: _listHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: clubs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final club = clubs[index];
                return _ClubCard(
                  club: club,
                  colorIndex: index,
                  joined: isJoined(club),
                  members: memberCount(club),
                  onToggle: () => onToggleJoin(club),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lavenderDeepGlow,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    Flexible(
                      child: Text(
                        CommunityStrings.clubBadge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.eyebrow.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            LinkButton(
              label: CommunityStrings.seeAllClubs,
              trailingIcon: Icons.chevron_right_rounded,
              style: AppTextStyles.label,
              onPressed: () => showComingSoon(context),
            ),
          ],
        ),
        Text(CommunityStrings.clubTitle, style: AppTextStyles.title),
        Text(CommunityStrings.clubSubtitle, style: AppTextStyles.caption),
      ],
    );
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({
    required this.club,
    required this.colorIndex,
    required this.joined,
    required this.members,
    required this.onToggle,
  });

  final BirdClub club;
  final int colorIndex;
  final bool joined;
  final int members;
  final VoidCallback onToggle;

  static const double _width = 200;
  static const double _avatarSize = 56;
  static const List<Color> _avatarColors = [
    AppColors.primary,
    AppColors.onLime,
    AppColors.onPink,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        spacing: 8,
        children: [
          InitialsAvatar(
            initials: club.initials,
            size: _avatarSize,
            color: _avatarColors[colorIndex % _avatarColors.length],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Flexible(
                child: Text(
                  club.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (club.verified)
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
            ],
          ),
          _ClubStats(members: members, trophies: club.trophies),
          const Spacer(),
          _JoinButton(joined: joined, onPressed: onToggle),
        ],
      ),
    );
  }
}

class _ClubStats extends StatelessWidget {
  const _ClubStats({required this.members, required this.trophies});

  final int members;
  final int trophies;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(
          '${formatThousands(members)} ${CommunityStrings.membersSuffix}',
          style: AppTextStyles.caption,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              size: 14,
              color: AppColors.onLime,
            ),
            Text(
              '$trophies',
              style: AppTextStyles.caption.copyWith(color: AppColors.onLime),
            ),
          ],
        ),
      ],
    );
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.joined, required this.onPressed});

  final bool joined;
  final VoidCallback onPressed;

  static const double _height = 36;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(_height),
        padding: EdgeInsets.zero,
        backgroundColor: joined ? AppColors.lavender : AppColors.primary,
        foregroundColor: joined ? AppColors.primary : AppColors.surface,
        textStyle: AppTextStyles.label,
      ),
      child: Text(joined ? CommunityStrings.joined : CommunityStrings.join),
    );
  }
}
