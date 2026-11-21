import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tones.dart';

/// Kartu bergradient pastel dengan radius panel; dasar kartu Beranda.
class ToneCard extends StatelessWidget {
  const ToneCard({
    super.key,
    required this.tone,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final PastelTone tone;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: tone.gradient,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: child,
    );
  }
}
