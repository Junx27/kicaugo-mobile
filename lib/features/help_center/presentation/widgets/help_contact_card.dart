import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/help_center_content.dart';
import 'help_pill_button.dart';

typedef _ContactVisual = ({IconData icon, IconData actionIcon});

_ContactVisual _visualFor(HelpContactKind kind) => switch (kind) {
  HelpContactKind.coordinator => (
    icon: Icons.person_pin_rounded,
    actionIcon: Icons.call_rounded,
  ),
  HelpContactKind.medical => (
    icon: Icons.pets_rounded,
    actionIcon: Icons.call_rounded,
  ),
  HelpContactKind.secretariat => (
    icon: Icons.apartment_rounded,
    actionIcon: Icons.support_agent_rounded,
  ),
};

/// Baris kontak panitia dengan tombol aksi cepat.
class HelpContactCard extends StatelessWidget {
  const HelpContactCard({super.key, required this.contact});

  final HelpContact contact;

  @override
  Widget build(BuildContext context) {
    final visual = _visualFor(contact.kind);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(visual.icon, size: 20, color: AppColors.primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  contact.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  contact.role,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          HelpPillButton(
            key: Key('help_contact_${contact.id}'),
            label: contact.actionLabel,
            icon: visual.actionIcon,
            compact: true,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.primary,
            onPressed: () => showComingSoon(context),
          ),
        ],
      ),
    );
  }
}
