import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../domain/entities/reminders_content.dart';
import '../reminders_strings.dart';

/// Warna kartu rawatan: maksimal tiga tone pastel, sisanya netral.
typedef _CareLook = ({
  Color background,
  Color title,
  Color detail,
  bool outlined,
});

_CareLook _lookOf(CareReminder reminder) {
  if (reminder.contestEveOnly) {
    return (
      background: AppTones.pink.light,
      title: AppTones.pink.foreground,
      detail: AppTones.pink.foreground,
      outlined: false,
    );
  }
  if (!reminder.isDone) {
    return (
      background: AppColors.surface,
      title: AppColors.textPrimary,
      detail: AppColors.textSecondary,
      outlined: true,
    );
  }
  final tone = reminder.kind == CareKind.feeding
      ? AppTones.periwinkle
      : AppTones.lime;
  return (
    background: tone.strong,
    title: tone.foreground,
    detail: tone.foreground,
    outlined: false,
  );
}

IconData _iconOf(CareKind kind) => switch (kind) {
  CareKind.sunlight => Icons.wb_sunny_rounded,
  CareKind.feeding => Icons.restaurant_rounded,
  CareKind.training => Icons.graphic_eq_rounded,
  CareKind.grooming => Icons.nightlight_round,
};

/// Judul, badge progres, dan daftar kartu rawatan hari ini.
class CareScheduleSection extends StatelessWidget {
  const CareScheduleSection({
    super.key,
    required this.reminders,
    required this.doneCount,
    required this.onToggleDone,
    required this.onToggleAlarm,
  });

  final List<CareReminder> reminders;
  final int doneCount;
  final ValueChanged<String> onToggleDone;
  final ValueChanged<String> onToggleAlarm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: Text(
                RemindersStrings.careToday,
                style: AppTextStyles.sectionTitle,
              ),
            ),
            _ProgressBadge(done: doneCount, total: reminders.length),
          ],
        ),
        if (reminders.isEmpty)
          Text(
            RemindersStrings.emptyCare,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          )
        else
          for (final reminder in reminders)
            _CareCard(
              key: Key('reminders_care_${reminder.id}'),
              reminder: reminder,
              onToggleDone: () => onToggleDone(reminder.id),
              onToggleAlarm: () => onToggleAlarm(reminder.id),
            ),
      ],
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTones.lime.light,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        RemindersStrings.progress(done, total),
        style: AppTextStyles.label.copyWith(color: AppTones.lime.foreground),
      ),
    );
  }
}

class _CareCard extends StatelessWidget {
  const _CareCard({
    super.key,
    required this.reminder,
    required this.onToggleDone,
    required this.onToggleAlarm,
  });

  final CareReminder reminder;
  final VoidCallback onToggleDone;
  final VoidCallback onToggleAlarm;

  @override
  Widget build(BuildContext context) {
    final look = _lookOf(reminder);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: look.background,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        border: look.outlined ? Border.all(color: AppColors.border) : null,
        boxShadow: look.outlined ? AppTheme.softShadow : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _DoneCheckbox(
            key: Key('reminders_care_done_${reminder.id}'),
            isDone: reminder.isDone,
            background: look.outlined
                ? AppColors.surfaceLavender
                : AppColors.surface,
            onTap: onToggleDone,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      RemindersStrings.careTime(reminder.time, reminder.title),
                      style: AppTextStyles.label.copyWith(color: look.title),
                    ),
                    if (reminder.contestEveOnly)
                      _EveBadge(foreground: look.title),
                  ],
                ),
                Text(
                  reminder.detail,
                  style: AppTextStyles.caption.copyWith(color: look.detail),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (reminder.isDone)
            _KindIcon(kind: reminder.kind, color: look.title)
          else
            Switch(
              key: Key('reminders_care_alarm_${reminder.id}'),
              value: reminder.alarmOn,
              onChanged: (_) => onToggleAlarm(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
        ],
      ),
    );
  }
}

class _DoneCheckbox extends StatelessWidget {
  const _DoneCheckbox({
    super.key,
    required this.isDone,
    required this.background,
    required this.onTap,
  });

  final bool isDone;
  final Color background;
  final VoidCallback onTap;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: RemindersStrings.doneTooltip,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.checkboxRadius),
          ),
          child: Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: isDone ? AppColors.primary : background,
              borderRadius: BorderRadius.circular(AppTheme.checkboxRadius),
            ),
            child: isDone
                ? const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppColors.surface,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _EveBadge extends StatelessWidget {
  const _EveBadge({required this.foreground});

  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        RemindersStrings.contestEve,
        style: AppTextStyles.eyebrow.copyWith(
          color: foreground,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _KindIcon extends StatelessWidget {
  const _KindIcon({required this.kind, required this.color});

  final CareKind kind;
  final Color color;

  static const double _size = 36;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(_iconOf(kind), size: 18, color: color),
    );
  }
}
