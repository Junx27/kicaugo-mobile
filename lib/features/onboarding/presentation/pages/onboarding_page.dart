import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/onboarding_cubit.dart';
import '../models/onboarding_slide.dart';
import '../widgets/onboarding_cta.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/showcase_card.dart';
import '../widgets/slide_tabs.dart';
import '../widgets/slide_text.dart';
import '../widgets/stat_tiles.dart';

/// Onboarding tiga slide; bisa digeser, dipilih lewat tab, atau via CTA.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, this.slides = onboardingSlides});

  final List<OnboardingSlide> slides;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(slideCount: slides.length),
      child: _OnboardingView(slides: slides),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView({required this.slides});

  final List<OnboardingSlide> slides;

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  static const Duration _slideDuration = Duration(milliseconds: 300);

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish() => context.go(AppRoutes.login);

  void _onCtaPressed() {
    final cubit = context.read<OnboardingCubit>();
    if (cubit.isLast) {
      _finish();
    } else {
      cubit.next();
    }
  }

  /// Menggeser kartu mengikuti indeks cubit (dari tab atau CTA).
  void _syncPage(BuildContext context, int index) {
    if (_pageController.page?.round() != index) {
      _pageController.animateToPage(
        index,
        duration: _slideDuration,
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<OnboardingCubit, int>(
          listener: _syncPage,
          builder: (context, current) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OnboardingHeader(onSkip: _finish),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: AppTheme.showcaseAspectRatio,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: cubit.select,
                    children: [
                      for (final slide in widget.slides)
                        ShowcaseCard(slide: slide),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.itemSpacing),
                SlideTabs(
                  slides: widget.slides,
                  current: current,
                  onSelected: cubit.select,
                ),
                const SizedBox(height: 16),
                SlideText(slides: widget.slides, current: current),
                const SizedBox(height: 16),
                const StatTiles(),
                const SizedBox(height: AppTheme.sectionSpacing),
                OnboardingCta(
                  label: widget.slides[current].ctaLabel,
                  onPressed: _onCtaPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
