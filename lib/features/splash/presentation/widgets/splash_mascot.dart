import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Kartu maskot burung dengan tiga aksen pastel (bintang, not, badge PRO).
class SplashMascot extends StatefulWidget {
  const SplashMascot({super.key});

  @override
  State<SplashMascot> createState() => _SplashMascotState();
}

class _SplashMascotState extends State<SplashMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<Offset> _bounce = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.25),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const _MascotCard(),
        Positioned(
          top: -14,
          right: -14,
          child: SlideTransition(
            position: _bounce,
            child: const _AccentBadge(
              size: 36,
              iconSize: 18,
              icon: Icons.star_rounded,
              color: AppColors.yellow,
              iconColor: AppColors.onYellow,
            ),
          ),
        ),
        const Positioned(
          left: -24,
          top: 0,
          bottom: 0,
          child: Center(
            child: _AccentBadge(
              size: 32,
              iconSize: 16,
              icon: Icons.music_note_rounded,
              color: AppColors.pink,
              iconColor: AppColors.onPink,
            ),
          ),
        ),
        const Positioned(bottom: -12, right: -8, child: _ProBadge()),
      ],
    );
  }
}

class _MascotCard extends StatelessWidget {
  const _MascotCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.mascotCardSize,
      height: AppTheme.mascotCardSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.mascotCardRadius),
        border: Border.all(color: AppColors.lavender),
        boxShadow: AppTheme.raisedShadow,
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            AppColors.lavenderTintStart,
            AppColors.surface,
            AppColors.lavenderTintEnd,
          ],
        ),
      ),
      child: SvgPicture.asset(
        AppConstants.mascotAsset,
        width: AppTheme.mascotSize,
        height: AppTheme.mascotSize,
      ),
    );
  }
}

class _AccentBadge extends StatelessWidget {
  const _AccentBadge({
    required this.size,
    required this.iconSize,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  final double size;
  final double iconSize;
  final IconData icon;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: AppTheme.softShadow,
      ),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        border: Border.all(color: AppColors.limeStrong),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco_rounded, size: 13, color: AppColors.onLime),
          const SizedBox(width: 4),
          Text(
            AppConstants.splashProBadge,
            style: AppTextStyles.eyebrow.copyWith(
              color: AppColors.onLime,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
