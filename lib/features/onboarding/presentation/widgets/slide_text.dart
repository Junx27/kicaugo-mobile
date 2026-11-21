import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/page_indicator.dart';
import '../models/onboarding_slide.dart';

/// Indikator halaman, judul, dan deskripsi slide aktif.
class SlideText extends StatelessWidget {
  const SlideText({super.key, required this.slides, required this.current});

  final List<OnboardingSlide> slides;
  final int current;

  static const Duration _fadeDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final slide = slides[current];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageIndicator(count: slides.length, current: current),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: _fadeDuration,
          layoutBuilder: (currentChild, previousChildren) => Stack(
            alignment: Alignment.topLeft,
            children: [...previousChildren, ?currentChild],
          ),
          child: Column(
            key: ValueKey<int>(current),
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Text(slide.title, style: AppTextStyles.headline),
              Text(
                slide.description,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
