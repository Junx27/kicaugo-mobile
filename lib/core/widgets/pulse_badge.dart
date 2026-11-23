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
    this.backgroundColor = AppColors.lavenderGlow,
    this.accentColor = AppColors.onPink,
    this.icon,
  });

  final String label;
  final Color backgroundColor;

  /// Warna titik berdenyut dan teks.
  final Color accentColor;

  /// Ikon opsional yang menggantikan titik berdenyut.
  final IconData? icon;

  /// Metrik mengikuti chip kategori Beranda agar ukurannya identik.
  static const double _height = 32;
  static const double _horizontalPadding = 12;
  static const double _gap = 4;

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
        padding: const EdgeInsets.symmetric(
          horizontal: PulseBadge._horizontalPadding,
        ),
        child: SizedBox(
          height: PulseBadge._height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: PulseBadge._gap,
            children: [
              if (widget.icon != null)
                FadeTransition(
                  opacity: _opacity,
                  child: Icon(
                    widget.icon,
                    size: 14,
                    weight: 700,
                    color: widget.accentColor,
                  ),
                )
              else
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
      ),
    );
  }
}
