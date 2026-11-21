import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glow_orb.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../models/onboarding_slide.dart';
import '../onboarding_strings.dart';
import 'showcase_mascot.dart';

/// Kartu pastel besar per slide: badge, maskot dengan stiker, chip kelas.
class ShowcaseCard extends StatelessWidget {
  const ShowcaseCard({super.key, required this.slide});

  final OnboardingSlide slide;

  static const double _glowOffset = -40;
  static const double _radarSize = 32;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: slide.tone.gradient,
        borderRadius: BorderRadius.circular(AppTheme.showcaseRadius),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: _glowOffset,
            right: _glowOffset,
            child: GlowOrb(
              size: 176,
              color: AppColors.surface,
              alpha: 0.25,
              blurSigma: 12,
            ),
          ),
          Positioned(
            bottom: _glowOffset,
            left: _glowOffset,
            child: GlowOrb(
              size: 144,
              color: slide.tone.strong,
              alpha: 0.4,
              blurSigma: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconPill(
                      icon: slide.badge.icon,
                      label: slide.badge.label,
                      backgroundAlpha: 0.85,
                    ),
                    const _RadarButton(size: _radarSize),
                  ],
                ),
                const ShowcaseMascot(),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final name in OnboardingStrings.birdClasses)
                      IconPill(label: name, backgroundAlpha: 0.9),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarButton extends StatelessWidget {
  const _RadarButton({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        boxShadow: AppTheme.softShadow,
      ),
      child: const Icon(
        Icons.radar_rounded,
        size: 18,
        color: AppColors.primary,
      ),
    );
  }
}
