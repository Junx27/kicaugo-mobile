import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/help_center_content.dart';
import '../help_center_strings.dart';
import 'help_pill_button.dart';

class _ActionVisual {
  const _ActionVisual({
    required this.icon,
    required this.background,
    required this.foreground,
    this.gradient,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final Gradient? gradient;
}

_ActionVisual _visualFor(HelpActionKind kind) => switch (kind) {
  HelpActionKind.chat => _ActionVisual(
    icon: Icons.chat_rounded,
    background: AppTones.yellow.light,
    foreground: AppTones.yellow.foreground,
    gradient: AppTones.yellow.gradient,
  ),
  HelpActionKind.refund => _ActionVisual(
    icon: Icons.replay_circle_filled_rounded,
    background: AppTones.periwinkle.light,
    foreground: AppTones.periwinkle.foreground,
    gradient: AppTones.periwinkle.gradient,
  ),
  HelpActionKind.appeal => _ActionVisual(
    icon: Icons.gavel_rounded,
    background: AppTones.lime.light,
    foreground: AppTones.lime.foreground,
    gradient: AppTones.lime.gradient,
  ),
  HelpActionKind.payment => const _ActionVisual(
    icon: Icons.qr_code_scanner_rounded,
    background: AppColors.surfaceLavender,
    foreground: AppColors.primary,
  ),
};

/// Grid 2 kolom berisi empat aksi cepat bantuan.
class HelpQuickActions extends StatelessWidget {
  const HelpQuickActions({super.key, required this.actions});

  final List<HelpQuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                HelpCenterStrings.quickTitle,
                style: AppTextStyles.title,
              ),
            ),
            Text(
              HelpCenterStrings.quickCount(actions.length),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        for (var index = 0; index < actions.length; index += 2)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Expanded(child: _QuickActionCard(action: actions[index])),
                Expanded(
                  child: index + 1 < actions.length
                      ? _QuickActionCard(action: actions[index + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final HelpQuickAction action;

  @override
  Widget build(BuildContext context) {
    final visual = _visualFor(action.kind);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: visual.gradient,
        color: visual.gradient == null ? visual.background : null,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: visual.foreground.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(visual.icon, size: 22, color: visual.foreground),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Text(
                  action.badge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: visual.foreground,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action.title,
                style: AppTextStyles.cardTitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                action.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: HelpPillButton(
              key: Key('help_action_${action.id}'),
              label: action.ctaLabel,
              icon: Icons.arrow_forward_rounded,
              onPressed: () => showComingSoon(context),
            ),
          ),
        ],
      ),
    );
  }
}
