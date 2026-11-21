import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Pasangan warna pastel searah (terang → kuat) untuk kartu bergradient.
@immutable
class PastelTone {
  const PastelTone({
    required this.light,
    required this.strong,
    required this.foreground,
  });

  final Color light;
  final Color strong;

  /// Warna ikon/teks aksen yang kontras di atas tone ini.
  final Color foreground;

  /// Gradient tonal halus dari kiri atas ke kanan bawah.
  LinearGradient get gradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [light, strong],
  );
}

/// Daftar tone pastel KicauGo. Maksimal tiga tone per layar.
abstract final class AppTones {
  static const PastelTone yellow = PastelTone(
    light: AppColors.yellow,
    strong: AppColors.yellowStrong,
    foreground: AppColors.onYellow,
  );

  static const PastelTone pink = PastelTone(
    light: AppColors.pink,
    strong: AppColors.pinkStrong,
    foreground: AppColors.onPink,
  );

  static const PastelTone lime = PastelTone(
    light: AppColors.lime,
    strong: AppColors.limeStrong,
    foreground: AppColors.onLime,
  );

  static const PastelTone periwinkle = PastelTone(
    light: AppColors.periwinkle,
    strong: AppColors.periwinkleStrong,
    foreground: AppColors.primary,
  );
}
