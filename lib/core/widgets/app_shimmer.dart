import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';

/// Pembungkus shimmer dengan palet dan kecepatan standar aplikasi.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.period = _defaultPeriod,
  });

  final Widget child;
  final bool enabled;
  final Duration period;

  static const Duration _defaultPeriod = Duration(milliseconds: 1200);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surfaceLavender,
      period: period,
      enabled: enabled,
      child: child,
    );
  }
}
