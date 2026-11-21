import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/color_pill.dart';
import '../../../../core/widgets/glow_orb.dart';
import '../../domain/entities/featured_event.dart';
import '../schedule_format.dart';
import '../schedule_strings.dart';
import 'schedule_icon_text.dart';

/// Kartu hero event unggulan (kuning ke lime lembut).
class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({super.key, required this.event});

  final FeaturedEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.yellow, AppColors.lime, AppColors.inputFill],
        ),
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        border: Border.all(
          color: AppColors.yellowStrong.withValues(alpha: 0.4),
        ),
        boxShadow: AppTheme.softShadow,
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -32,
            top: -32,
            child: GlowOrb(
              size: 144,
              color: AppColors.limeStrong,
              alpha: 0.4,
              blurSigma: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                _Badges(event: event),
                Text(
                  event.meta.countdown,
                  style: AppTextStyles.label.copyWith(color: AppColors.onLime),
                ),
                Text(
                  event.meta.judges,
                  style: AppTextStyles.label.copyWith(color: AppColors.primary),
                ),
                Text(event.headline.title, style: AppTextStyles.headlineSmall),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    ScheduleIconText(
                      icon: Icons.calendar_today_rounded,
                      iconColor: AppColors.primary,
                      text: longDate(event.slot.date),
                    ),
                    ScheduleIconText(
                      icon: Icons.schedule_rounded,
                      iconColor: AppColors.onLime,
                      text: event.slot.time,
                    ),
                  ],
                ),
                ScheduleIconText(
                  icon: Icons.pin_drop_rounded,
                  iconColor: AppColors.primary,
                  text: event.slot.venue,
                ),
                Divider(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                _Reward(prize: event.prize),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges({required this.event});

  final FeaturedEvent event;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.eyebrow.copyWith(letterSpacing: 0);
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _Pill(
          color: AppColors.primary,
          children: [
            const Icon(
              Icons.verified_rounded,
              size: 14,
              color: AppColors.surface,
            ),
            Text(
              event.headline.badge,
              style: style.copyWith(color: AppColors.surface),
            ),
          ],
        ),
        _Pill(
          color: AppColors.pink,
          children: [
            const ColorPill.dot(size: 6, color: AppColors.onPink),
            Text(
              event.meta.remaining,
              style: style.copyWith(color: AppColors.onPink),
            ),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.color, required this.children});

  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: children,
      ),
    );
  }
}

class _Reward extends StatelessWidget {
  const _Reward({required this.prize});

  final String prize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ScheduleStrings.totalPrize, style: AppTextStyles.eyebrow),
            Text(
              prize,
              style: AppTextStyles.title.copyWith(color: AppColors.onLime),
            ),
          ],
        ),
        FilledButton(
          onPressed: () => showComingSoon(context),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 18),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Flexible(
                child: Text(
                  ScheduleStrings.bookNow,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}
