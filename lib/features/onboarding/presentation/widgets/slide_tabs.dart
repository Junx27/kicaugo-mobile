import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/onboarding_slide.dart';

/// Tiga chip bernomor untuk melompat langsung ke slide tertentu.
class SlideTabs extends StatelessWidget {
  const SlideTabs({
    super.key,
    required this.slides,
    required this.current,
    required this.onSelected,
  });

  final List<OnboardingSlide> slides;
  final int current;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        for (var index = 0; index < slides.length; index++)
          Expanded(
            child: _SlideTab(
              number: index + 1,
              slide: slides[index],
              isActive: index == current,
              onTap: () => onSelected(index),
            ),
          ),
      ],
    );
  }
}

class _SlideTab extends StatelessWidget {
  const _SlideTab({
    required this.number,
    required this.slide,
    required this.isActive,
    required this.onTap,
  });

  final int number;
  final OnboardingSlide slide;
  final bool isActive;
  final VoidCallback onTap;

  static const double _inactiveOpacity = 0.8;
  static const double _ringWidth = 2;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: isActive
          ? const BorderSide(color: AppColors.primaryRing, width: _ringWidth)
          : BorderSide.none,
    );
    return Opacity(
      opacity: isActive ? 1 : _inactiveOpacity,
      child: Material(
        color: slide.tone.light,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Icon(slide.tab.icon, size: 14, color: AppColors.textPrimary),
                Flexible(
                  child: Text(
                    '$number. ${slide.tab.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
