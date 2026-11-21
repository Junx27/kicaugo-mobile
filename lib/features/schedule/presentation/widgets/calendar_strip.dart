import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/color_pill.dart';
import '../../../../core/widgets/link_button.dart';
import '../../domain/entities/calendar_day.dart';
import '../../domain/entities/schedule_filter.dart';
import '../schedule_format.dart';
import '../schedule_strings.dart';

/// Kartu strip kalender 7 hari dengan ringkasan event hari terpilih.
class CalendarStrip extends StatelessWidget {
  const CalendarStrip({
    super.key,
    required this.days,
    required this.selected,
    required this.onSelected,
    required this.periodLabel,
    required this.eventCount,
  });

  final List<CalendarDay> days;
  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  /// Bulan dan pekan (mis. "Nov 2026" dan "Minggu ke-3").
  final ({String month, String week}) periodLabel;

  /// Jumlah agenda yang tampil untuk hari terpilih.
  final int eventCount;

  @override
  Widget build(BuildContext context) {
    final selectedDay = days.firstWhere((day) => isSameDay(day.date, selected));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        border: Border.all(color: AppColors.lavenderGlow),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          _Header(periodLabel: periodLabel),
          Row(
            spacing: 4,
            children: [
              for (final day in days)
                Expanded(
                  child: _DayCell(
                    day: day,
                    isSelected: isSameDay(day.date, selected),
                    onTap: () => onSelected(day.date),
                  ),
                ),
            ],
          ),
          const Divider(color: AppColors.lavenderGlow),
          _Footer(day: selectedDay, eventCount: eventCount),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.periodLabel});

  final ({String month, String week}) periodLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4,
      children: [
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(periodLabel.month, style: AppTextStyles.title),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lavenderGlow,
                borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              ),
              child: Text(
                periodLabel.week,
                style: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        LinkButton(
          label: ScheduleStrings.fullCalendar,
          trailingIcon: Icons.chevron_right_rounded,
          style: AppTextStyles.label,
          onPressed: () => showComingSoon(context),
        ),
      ],
    );
  }
}

/// Warna sel hari: latar, teks utama, dan teks label.
typedef _CellColors = ({Color background, Color text, Color label});

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final CalendarDay day;
  final bool isSelected;
  final VoidCallback onTap;

  _CellColors get _colors {
    if (isSelected) {
      return (
        background: AppColors.primary,
        text: AppColors.surface,
        label: AppColors.surface,
      );
    }
    final tone = day.accent?.tone;
    if (tone == null) {
      return (
        background: AppColors.inputFill,
        text: AppColors.textPrimary,
        label: AppColors.textSecondary,
      );
    }
    return (
      background: tone.light.withValues(alpha: 0.6),
      text: AppColors.textPrimary,
      label: tone.foreground,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: Column(
              spacing: 2,
              children: [
                Text(
                  weekdayShort(day.date),
                  style: AppTextStyles.eyebrow.copyWith(color: colors.label),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${day.date.day}',
                    style: AppTextStyles.title.copyWith(color: colors.text),
                  ),
                ),
                _DayLabel(
                  text: isSelected && day.isPeak
                      ? ScheduleStrings.peakBadge
                      : day.label,
                  color: colors.label,
                  highlighted: isSelected && day.isPeak,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({
    required this.text,
    required this.color,
    required this.highlighted,
  });

  final String text;
  final Color color;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final label = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        maxLines: 1,
        style: AppTextStyles.eyebrow.copyWith(
          color: highlighted ? AppColors.onLime : color,
          fontSize: 9,
          letterSpacing: 0,
        ),
      ),
    );
    if (!highlighted) {
      return label;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: label,
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.day, required this.eventCount});

  final CalendarDay day;
  final int eventCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            const ColorPill.dot(size: 8, color: AppColors.limeStrong),
            Flexible(
              child: Text.rich(
                TextSpan(
                  text: '$eventCount ${ScheduleStrings.eventsSuffix} ',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${ScheduleStrings.availablePrefix} '
                          '${weekdayName(day.date)} '
                          '${ScheduleStrings.availableSuffix}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (day.isPeak)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
            ),
            child: Text(
              ScheduleStrings.peakDay,
              style: AppTextStyles.eyebrow.copyWith(color: AppColors.onLime),
            ),
          ),
      ],
    );
  }
}
