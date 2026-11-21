import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../profile_strings.dart';
import 'profile_section_header.dart';

class _ProfileService {
  const _ProfileService({
    required this.icon,
    required this.title,
    required this.note,
    required this.actionKey,
    this.isLocked = false,
  });

  final IconData icon;
  final String title;
  final String note;
  final Key actionKey;
  final bool isLocked;
}

const List<_ProfileService> _services = <_ProfileService>[
  _ProfileService(
    icon: Icons.fingerprint_rounded,
    title: ProfileStrings.serviceRingTitle,
    note: ProfileStrings.serviceRingNote,
    actionKey: Key('profile_service_ring'),
  ),
  _ProfileService(
    icon: Icons.graphic_eq_rounded,
    title: ProfileStrings.serviceAudioTitle,
    note: ProfileStrings.serviceAudioNote,
    actionKey: Key('profile_service_audio'),
  ),
  _ProfileService(
    icon: Icons.storefront_rounded,
    title: ProfileStrings.serviceMarketTitle,
    note: ProfileStrings.serviceMarketNote,
    actionKey: Key('profile_service_market'),
    isLocked: true,
  ),
];

/// Daftar layanan Kicaumania; satu layanan ditandai belum tersedia.
class ProfileServicesSection extends StatelessWidget {
  const ProfileServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        const ProfileSectionHeader(title: ProfileStrings.servicesTitle),
        for (final service in _services) _ServiceTile(service: service),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});

  final _ProfileService service;

  @override
  Widget build(BuildContext context) {
    final locked = service.isLocked;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: locked ? null : AppTheme.softShadow,
      ),
      child: Material(
        color: locked ? AppColors.surfaceLavender : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: service.actionKey,
          onTap: locked ? null : () => showComingSoon(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 12,
              children: [
                _ServiceIcon(icon: service.icon, locked: locked),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              service.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.cardTitle.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (locked) ...[
                            const SizedBox(width: 8),
                            const _SoonBadge(),
                          ],
                        ],
                      ),
                      Text(
                        service.note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Icon(
                  locked
                      ? Icons.lock_outline_rounded
                      : Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  const _ServiceIcon({required this.icon, required this.locked});

  final IconData icon;
  final bool locked;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: locked ? AppColors.lavender : AppColors.lavenderGlow,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Icon(
        icon,
        size: 24,
        color: locked ? AppColors.textSecondary : AppColors.primary,
      ),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTones.yellow.light,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        ProfileStrings.soon,
        style: AppTextStyles.eyebrow.copyWith(
          color: AppTones.yellow.foreground,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
