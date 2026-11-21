import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/profile_content.dart';
import '../profile_strings.dart';

/// Grid 2×2 statistik profil: trofi, kehadiran, amunisi, dan KicauPay.
class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({super.key, required this.stats});

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        _StatsRow(
          first: _StatTile(
            tone: AppTones.yellow,
            icon: Icons.emoji_events_rounded,
            badge: ProfileStrings.trophyBadge,
            value: '${stats.trophies}',
            unit: ProfileStrings.trophyUnit,
            note: stats.medals,
          ),
          second: _StatTile(
            tone: AppTones.lime,
            icon: Icons.task_alt_rounded,
            badge: ProfileStrings.attendanceBadge,
            value: '${stats.attendance}%',
            note: ProfileStrings.attendanceNote,
          ),
        ),
        _StatsRow(
          first: _StatTile(
            tone: AppTones.periwinkle,
            icon: Icons.cruelty_free_rounded,
            badge: ProfileStrings.birdsBadge,
            value: '${stats.birdsReady}',
            unit: ProfileStrings.birdsUnit,
            note: ProfileStrings.birdsNote,
          ),
          second: _BalanceTile(balance: stats.balance),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Expanded(child: first),
          Expanded(child: second),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.tone,
    required this.icon,
    required this.badge,
    required this.value,
    required this.note,
    this.unit,
  });

  final PastelTone tone;
  final IconData icon;
  final String badge;
  final String value;
  final String? unit;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: tone.gradient,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _TileIcon(icon: icon, color: tone.foreground),
              const Spacer(),
              Flexible(
                child: _TileBadge(label: badge, color: tone.foreground),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                _ValueRow(
                  value: value,
                  unit: unit,
                  color: AppColors.textPrimary,
                ),
                Text(
                  note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
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

class _BalanceTile extends StatelessWidget {
  const _BalanceTile({required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryPressed],
        ),
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              _TileIcon(
                icon: Icons.account_balance_wallet_rounded,
                color: AppColors.surface,
              ),
              Spacer(),
              _TopUpButton(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  ProfileStrings.walletLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.8),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    balance,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  ProfileStrings.walletNote,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.8),
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

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  static const double _size = 36;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _TileBadge extends StatelessWidget {
  const _TileBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.eyebrow.copyWith(color: color, letterSpacing: 0),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.value, required this.color, this.unit});

  final String value;
  final String? unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      spacing: 4,
      children: [
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headline.copyWith(color: color),
          ),
        ),
        if (unit != null)
          Text(
            unit!,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _TopUpButton extends StatelessWidget {
  const _TopUpButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('profile_topup'),
      onPressed: () => showComingSoon(context),
      style: TextButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        minimumSize: const Size(44, 24),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        textStyle: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
      ),
      child: const Text(ProfileStrings.topUp),
    );
  }
}
