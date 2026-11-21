import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../reminders_strings.dart';

/// Pengaturan nada dering dan mode getar.
class ReminderAlertSettings extends StatelessWidget {
  const ReminderAlertSettings({
    super.key,
    required this.ringtone,
    required this.vibrationOn,
    required this.onPlayRingtone,
    required this.onVibrationChanged,
  });

  final String ringtone;
  final bool vibrationOn;
  final VoidCallback onPlayRingtone;
  final ValueChanged<bool> onVibrationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      child: Column(
        spacing: 12,
        children: [
          _SettingRow(
            icon: Icons.music_note_rounded,
            iconBackground: AppColors.lavender,
            iconColor: AppColors.primary,
            title: RemindersStrings.ringtoneTitle,
            subtitle: ringtone,
            trailing: TextButton(
              key: const Key('reminders_play_ringtone'),
              onPressed: onPlayRingtone,
              style: AppTheme.softPillButton(
                foreground: AppColors.primary,
                textStyle: AppTextStyles.label,
              ),
              child: const Text(RemindersStrings.play),
            ),
          ),
          _SettingRow(
            icon: Icons.vibration_rounded,
            iconBackground: AppColors.lime,
            iconColor: AppColors.onLime,
            title: RemindersStrings.vibrationTitle,
            subtitle: RemindersStrings.vibrationDetail,
            trailing: Switch(
              key: const Key('reminders_vibration'),
              value: vibrationOn,
              onChanged: onVibrationChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          width: AppTheme.iconBoxSize,
          height: AppTheme.iconBoxSize,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                title,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
