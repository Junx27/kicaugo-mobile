import 'package:flutter/material.dart';

import '../entities/ticket_status.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../theme/app_tones.dart';

/// Tampilan per status: label, ikon, dan tone pastel.
typedef StatusLook = ({String label, IconData icon, PastelTone tone});

/// Chip status tiket: Tersedia (lime), Segera Habis (kuning), Habis (pink),
/// Menunggu (periwinkle).
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final TicketStatus status;

  static StatusLook lookOf(TicketStatus status) => switch (status) {
    TicketStatus.available => (
      label: 'Tersedia',
      icon: Icons.check_circle_rounded,
      tone: AppTones.lime,
    ),
    TicketStatus.almostGone => (
      label: 'Segera Habis',
      icon: Icons.local_fire_department_rounded,
      tone: AppTones.yellow,
    ),
    TicketStatus.soldOut => (
      label: 'Habis',
      icon: Icons.block_rounded,
      tone: AppTones.pink,
    ),
    TicketStatus.waiting => (
      label: 'Menunggu',
      icon: Icons.schedule_rounded,
      tone: AppTones.periwinkle,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final look = lookOf(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: look.tone.light,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(look.icon, size: 11, color: look.tone.foreground),
          Text(
            look.label,
            style: AppTextStyles.eyebrow.copyWith(
              color: look.tone.foreground,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
