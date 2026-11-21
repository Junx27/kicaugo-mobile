import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';

/// Pasangan label dan ikon (tab slide, badge kartu).
typedef LabeledIcon = ({String label, IconData icon});

/// Konten satu slide onboarding.
@immutable
class OnboardingSlide {
  const OnboardingSlide({
    required this.tab,
    required this.badge,
    required this.title,
    required this.description,
    required this.ctaLabel,
    required this.tone,
  });

  final LabeledIcon tab;
  final LabeledIcon badge;
  final String title;
  final String description;
  final String ctaLabel;
  final PastelTone tone;
}

/// Tiga slide onboarding: kuning, pink, lime.
const List<OnboardingSlide> onboardingSlides = <OnboardingSlide>[
  OnboardingSlide(
    tab: (label: 'Cari Lomba', icon: Icons.explore_rounded),
    badge: (label: 'JANGKAUAN NUSANTARA', icon: Icons.near_me_rounded),
    title: 'Temukan Lomba Terdekat',
    description:
        'Pantau jadwal latber, latpres, hingga piala nasional burung kicau '
        'favoritmu langsung dari genggaman tanpa ribet.',
    ctaLabel: 'Lanjut Jelajah',
    tone: AppTones.yellow,
  ),
  OnboardingSlide(
    tab: (label: 'Jadwal', icon: Icons.event_rounded),
    badge: (label: 'UPDATE REAL-TIME', icon: Icons.update_rounded),
    title: 'Jadwal Gantangan Akurat',
    description:
        'Informasi kelas, harga tiket, juri independen, dan regulasi '
        'penilaian terbuka secara transparan dan terukur.',
    ctaLabel: 'Lihat Fitur Tiket',
    tone: AppTones.pink,
  ),
  OnboardingSlide(
    tab: (label: 'Beli Tiket', icon: Icons.confirmation_number_rounded),
    badge: (
      label: 'SISTEM TIKET OTOMATIS',
      icon: Icons.qr_code_scanner_rounded,
    ),
    title: 'Pesan Tiket & Gantangan',
    description:
        'Pilih nomor gantangan idamanmu dalam hitungan detik. Tanpa calo, '
        'kode QR langsung aktif di smartphone.',
    ctaLabel: 'Mulai Sekarang',
    tone: AppTones.lime,
  ),
];
