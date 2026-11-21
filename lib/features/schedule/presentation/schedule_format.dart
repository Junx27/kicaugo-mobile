import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tones.dart';
import '../domain/entities/agenda.dart';
import '../domain/entities/schedule_region.dart';
import 'schedule_strings.dart';

const List<String> _weekdays = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Nama hari lengkap (mis. "Minggu").
String weekdayName(DateTime date) => _weekdays[date.weekday - 1];

/// Nama hari tiga huruf (mis. "Min").
String weekdayShort(DateTime date) => weekdayName(date).substring(0, 3);

/// Tanggal panjang (mis. "Minggu, 22 Nov 2026").
String longDate(DateTime date) =>
    '${weekdayName(date)}, ${date.day} ${_months[date.month - 1]} ${date.year}';

/// Label wilayah tanpa jumlah arena.
extension ScheduleRegionLabel on ScheduleRegion {
  String get label => switch (this) {
    ScheduleRegion.all => ScheduleStrings.allRegions,
    ScheduleRegion.jabodetabek => 'Jabodetabek',
    ScheduleRegion.jawaBarat => 'Jawa Barat',
    ScheduleRegion.jawaTengah => 'Jawa Tengah',
    ScheduleRegion.jawaTimur => 'Jawa Timur',
  };
}

/// Tone pastel untuk aksen kartu.
extension AgendaAccentTone on AgendaAccent {
  PastelTone get tone => switch (this) {
    AgendaAccent.periwinkle => AppTones.periwinkle,
    AgendaAccent.pink => AppTones.pink,
    AgendaAccent.lime => AppTones.lime,
    AgendaAccent.yellow => AppTones.yellow,
  };
}

/// Warna latar dan teks lencana per jenis.
typedef BadgeColors = ({Color background, Color foreground});

extension AgendaBadgeStyle on AgendaBadgeKind {
  BadgeColors get colors => switch (this) {
    AgendaBadgeKind.open => (
      background: AppColors.lime,
      foreground: AppColors.onLime,
    ),
    AgendaBadgeKind.almostFull => (
      background: AppColors.pink,
      foreground: AppColors.onPink,
    ),
    AgendaBadgeKind.promo => (
      background: AppColors.lavender,
      foreground: AppColors.primary,
    ),
    AgendaBadgeKind.info => (
      background: AppColors.surface,
      foreground: AppColors.onLime,
    ),
  };

  IconData get icon => switch (this) {
    AgendaBadgeKind.open => Icons.circle,
    AgendaBadgeKind.almostFull => Icons.local_fire_department_rounded,
    AgendaBadgeKind.promo => Icons.discount_rounded,
    AgendaBadgeKind.info => Icons.eco_rounded,
  };
}
