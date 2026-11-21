import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/color_pill.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../onboarding_strings.dart';

/// Maskot bertengger di lingkaran putih dengan dua stiker miring.
class ShowcaseMascot extends StatelessWidget {
  const ShowcaseMascot({super.key});

  /// Kemiringan stiker ±3 derajat.
  static const double _tilt = 3 * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const _MascotCircle(),
          Positioned(
            left: -8,
            top: 8,
            child: Transform.rotate(
              angle: -_tilt,
              child: const IconPill(
                icon: Icons.military_tech_rounded,
                iconColor: AppColors.onYellow,
                label: OnboardingStrings.stickerContests,
              ),
            ),
          ),
          Positioned(
            right: -8,
            bottom: 12,
            child: Transform.rotate(
              angle: _tilt,
              child: const IconPill(
                icon: Icons.schedule_rounded,
                label: OnboardingStrings.stickerSchedule,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MascotCircle extends StatelessWidget {
  const _MascotCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.mascotCardSize,
      height: AppTheme.mascotCardSize,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: AppTheme.raisedShadow,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: AppTheme.mascotInnerSize,
            height: AppTheme.mascotInnerSize,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.lavenderDeepGlow,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppConstants.mascotPerchAsset,
              width: AppTheme.mascotSize,
              height: AppTheme.mascotSize,
            ),
          ),
          const Positioned(top: 4, right: 8, child: _PingDot()),
        ],
      ),
    );
  }
}

/// Titik indigo dengan gelombang yang memudar (penanda real-time).
class _PingDot extends StatefulWidget {
  const _PingDot();

  @override
  State<_PingDot> createState() => _PingDotState();
}

class _PingDotState extends State<_PingDot>
    with SingleTickerProviderStateMixin {
  static const double _size = 14;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: 2,
  ).animate(_controller);

  late final Animation<double> _fade = Tween<double>(
    begin: 0.75,
    end: 0,
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: _scale,
          child: FadeTransition(
            opacity: _fade,
            child: const ColorPill.dot(size: _size, color: AppColors.primary),
          ),
        ),
        const ColorPill.dot(size: _size, color: AppColors.primary),
      ],
    );
  }
}
