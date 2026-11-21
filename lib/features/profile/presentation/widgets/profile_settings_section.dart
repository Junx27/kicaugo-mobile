import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../profile_strings.dart';
import 'profile_section_header.dart';

/// Pengaturan akun, bantuan, versi aplikasi, dan aksi keluar.
class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
    required this.onLogout,
    this.onHelp,
    this.onReminders,
    this.onTicketInvoices,
  });

  final VoidCallback onLogout;
  final VoidCallback? onHelp;
  final VoidCallback? onReminders;
  final VoidCallback? onTicketInvoices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        const ProfileSectionHeader(title: ProfileStrings.settingsTitle),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.panelRadius),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            children: [
              _SettingsRow(
                actionKey: const Key('profile_history'),
                icon: Icons.receipt_long_rounded,
                label: ProfileStrings.history,
                onTap: onTicketInvoices,
              ),
              _SettingsRow(
                actionKey: const Key('profile_reminders'),
                icon: Icons.notifications_active_rounded,
                label: ProfileStrings.reminders,
                onTap: onReminders,
              ),
              _SettingsRow(
                actionKey: const Key('profile_help'),
                icon: Icons.headset_mic_rounded,
                label: ProfileStrings.help,
                onTap: onHelp,
              ),
              _LogoutRow(onTap: onLogout),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.actionKey,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Key actionKey;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: actionKey,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: onTap ?? () => showComingSoon(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutRow extends StatelessWidget {
  const _LogoutRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: const Key('profile_logout'),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 20,
                color: AppColors.error,
              ),
              Expanded(
                child: Text(
                  ProfileStrings.logout,
                  style: AppTextStyles.label.copyWith(color: AppColors.error),
                ),
              ),
              Text(AppConstants.appVersionLabel, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}
