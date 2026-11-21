import 'package:flutter/material.dart';

import '../entities/bird_category.dart';
import '../theme/app_colors.dart';

/// Label, ikon, dan warna ikon per kategori burung.
extension BirdCategoryStyle on BirdCategory {
  String get label => switch (this) {
    BirdCategory.all => 'Semua Lomba',
    BirdCategory.muraiBatu => 'Murai Batu',
    BirdCategory.cucakHijau => 'Cucak Hijau',
    BirdCategory.kacer => 'Kacer',
    BirdCategory.anisMerah => 'Anis Merah',
    BirdCategory.kenari => 'Kenari',
    BirdCategory.lovebird => 'Lovebird',
  };

  IconData get icon => switch (this) {
    BirdCategory.all => Icons.local_fire_department_rounded,
    BirdCategory.muraiBatu => Icons.flutter_dash,
    BirdCategory.cucakHijau => Icons.park_rounded,
    BirdCategory.kacer => Icons.music_note_rounded,
    BirdCategory.anisMerah => Icons.whatshot_rounded,
    BirdCategory.kenari => Icons.wb_sunny_rounded,
    BirdCategory.lovebird => Icons.favorite_rounded,
  };

  Color get iconColor => switch (this) {
    BirdCategory.all => AppColors.onYellow,
    BirdCategory.muraiBatu => AppColors.primary,
    BirdCategory.cucakHijau => AppColors.onLime,
    BirdCategory.kacer => AppColors.textPrimary,
    BirdCategory.anisMerah => AppColors.onPink,
    BirdCategory.kenari => AppColors.onYellow,
    BirdCategory.lovebird => AppColors.onPink,
  };
}
