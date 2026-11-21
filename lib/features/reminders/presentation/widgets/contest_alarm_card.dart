import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/reminders_content.dart';
import '../reminders_strings.dart';

/// Kartu hero alarm lomba terdekat beserta pengingat H-1/H-2.
class ContestAlarmCard extends StatelessWidget {
  const ContestAlarmCard({
    super.key,
    required this.contest,
    required this.onToggleReminder,
    required this.onAddAlarm,
  });

  final ContestAlarm contest;
  final ValueChanged<String> onToggleReminder;
  final VoidCallback onAddAlarm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.pink, AppColors.periwinkle, AppColors.surface],
        ),
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        border: Border.all(color: AppColors.pinkStrong.withValues(alpha: 0.35)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 8,
            children: [
              const Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _Badge(
                    icon: Icons.alarm_on_rounded,
                    label: RemindersStrings.contestActive,
                    background: AppColors.surface,
                    foreground: AppColors.onPink,
                  ),
                ),
              ),
              _Badge(
                label: contest.countdown,
                background: AppColors.primary,
                foreground: AppColors.surface,
              ),
            ],
          ),
          Text(contest.title, style: AppTextStyles.headlineSmall),
          _MetaLine(icon: Icons.event_rounded, text: contest.schedule),
          _MetaLine(icon: Icons.place_rounded, text: contest.venue),
          for (final reminder in contest.reminders)
            _ContestReminderRow(
              key: Key('reminders_contest_${reminder.id}'),
              reminder: reminder,
              onChanged: () => onToggleReminder(reminder.id),
            ),
          TextButton.icon(
            key: const Key('reminders_add_contest'),
            onPressed: onAddAlarm,
            style: AppTheme.softPillButton(
              foreground: AppColors.primary,
              textStyle: AppTextStyles.button,
            ),
            icon: const Icon(Icons.add_alarm_rounded, size: 18),
            label: const Text(RemindersStrings.addAlarm),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final badgeIcon = icon;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (badgeIcon != null) Icon(badgeIcon, size: 14, color: foreground),
          Text(
            label,
            style: AppTextStyles.eyebrow.copyWith(
              color: foreground,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        Icon(
          icon,
          size: AppTheme.smallIconSize,
          color: AppColors.textSecondary,
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ContestReminderRow extends StatelessWidget {
  const _ContestReminderRow({
    super.key,
    required this.reminder,
    required this.onChanged,
  });

  final ContestReminder reminder;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  reminder.title,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  reminder.detail,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            key: Key('reminders_contest_switch_${reminder.id}'),
            value: reminder.isOn,
            onChanged: (_) => onChanged(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
