import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/pulse_badge.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_footer.dart';
import '../widgets/splash_hero.dart';

/// Splash screen KicauGo: tampil selama [duration] lalu pindah ke onboarding.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.duration = AppConstants.splashDuration});

  final Duration duration;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () => context.go(AppRoutes.onboarding));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(child: SplashBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: AppTheme.sectionSpacing,
              ),
              child: Column(
                children: [
                  const PulseBadge(label: AppConstants.splashEyebrow),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppTheme.splashContentMaxWidth,
                        ),
                        child: const SplashHero(),
                      ),
                    ),
                  ),
                  const SplashFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
