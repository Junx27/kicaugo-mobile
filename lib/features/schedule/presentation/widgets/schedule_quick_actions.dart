import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../schedule_strings.dart';

/// Dua widget cepat: peta arena (belum tersedia) dan alarm kalender.
class ScheduleQuickActions extends StatelessWidget {
  const ScheduleQuickActions({
    super.key,
    required this.mapDistance,
    required this.alarmOn,
    required this.onAlarmChanged,
  });

  final String mapDistance;
  final bool alarmOn;
  final ValueChanged<bool> onAlarmChanged;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Expanded(
            child: _ActionCard(
              color: AppColors.lavenderGlow,
              icon: Icons.map_rounded,
              iconColor: AppColors.primary,
              title: ScheduleStrings.mapTitle,
              subtitle: '$mapDistance ${ScheduleStrings.mapSuffix}',
              onTap: () => showComingSoon(context),
              footer: const Row(
                children: [
                  Expanded(
                    child: Text(
                      ScheduleStrings.openRoute,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.directions_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _ActionCard(
              color: AppColors.surface,
              icon: Icons.alarm_on_rounded,
              iconColor: AppColors.onLime,
              title: ScheduleStrings.alarmTitle,
              subtitle: ScheduleStrings.alarmSubtitle,
              footer: Row(
                children: [
                  Expanded(
                    child: Text(
                      alarmOn
                          ? ScheduleStrings.alarmOn
                          : ScheduleStrings.alarmOff,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Switch(
                    value: alarmOn,
                    onChanged: onAlarmChanged,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.footer,
    this.onTap,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget footer;
  final VoidCallback? onTap;

  static const double _iconBox = 36;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 1,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Container(
                width: _iconBox,
                height: _iconBox,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              Text(
                title,
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(subtitle, style: AppTextStyles.caption),
              const Spacer(),
              const Divider(color: AppColors.lavender),
              DefaultTextStyle(
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
                child: footer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
