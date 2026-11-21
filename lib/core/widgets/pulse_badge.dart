import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'color_pill.dart';

/// Pill eyebrow berhuruf kapital dengan titik indigo yang berdenyut.
class PulseBadge extends StatefulWidget {
  const PulseBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.lavender,
    this.accentColor = AppColors.primary,
  });

  final String label;
  final Color backgroundColor;

  /// Warna titik berdenyut dan teks.
  final Color accentColor;

  @override
  State<PulseBadge> createState() => _PulseBadgeState();
}

class _PulseBadgeState extends State<PulseBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.4,
    end: 1,
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            FadeTransition(
              opacity: _opacity,
              child: ColorPill.dot(size: 8, color: widget.accentColor),
            ),
            Flexible(
              child: Text(
                widget.label,
                style: AppTextStyles.eyebrow.copyWith(
                  color: widget.accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
