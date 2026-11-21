import 'package:flutter/material.dart';

import '../../../../core/entities/ticket_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/bird_category_style.dart';
import '../../../../core/widgets/link_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/entities/schedule_item.dart';
import '../home_strings.dart';

/// Bagian "Jadwal Gantangan Populer" beserta daftar atau keadaan kosong.
class PopularScheduleList extends StatelessWidget {
  const PopularScheduleList({super.key, required this.items});

  final List<ScheduleItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(HomeStrings.popularTitle, style: AppTextStyles.title),
                  Text(
                    HomeStrings.popularSubtitle,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            LinkButton(
              label: HomeStrings.seeAll,
              trailingIcon: Icons.chevron_right_rounded,
              style: AppTextStyles.label,
              onPressed: () => showComingSoon(context),
            ),
          ],
        ),
        if (items.isEmpty)
          const _EmptySchedules()
        else
          for (final item in items) _ScheduleTile(item: item),
      ],
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.item});

  final ScheduleItem item;

  static const double _iconBox = 48;

  @override
  Widget build(BuildContext context) {
    final tone = StatusChip.lookOf(item.status).tone;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: _iconBox,
            height: _iconBox,
            decoration: BoxDecoration(
              color: tone.light.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Icon(item.category.icon, color: tone.foreground),
          ),
          Expanded(child: _ScheduleInfo(item: item)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: [
              Text(
                item.price,
                style: AppTextStyles.title.copyWith(color: AppColors.primary),
              ),
              _BookButton(status: item.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleInfo extends StatelessWidget {
  const _ScheduleInfo({required this.item});

  final ScheduleItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusChip(status: item.status),
            Text(item.date, style: AppTextStyles.caption),
          ],
        ),
        Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.button.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          item.venue,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

/// Tombol "Pesan": menonjol saat segera habis, nonaktif saat habis.
class _BookButton extends StatelessWidget {
  const _BookButton({required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final isUrgent = status == TicketStatus.almostGone;
    return TextButton(
      onPressed: status == TicketStatus.soldOut
          ? null
          : () => showComingSoon(context),
      style:
          AppTheme.softPillButton(
            foreground: isUrgent ? AppColors.surface : AppColors.primary,
            textStyle: AppTextStyles.label,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => isUrgent ? AppColors.primary : AppColors.lavender,
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
          ),
      child: const Text(HomeStrings.book),
    );
  }
}

class _EmptySchedules extends StatelessWidget {
  const _EmptySchedules();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      child: Column(
        spacing: 8,
        children: [
          const Icon(Icons.event_busy_rounded, color: AppColors.primary),
          Text(
            HomeStrings.emptySchedules,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
