import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/tone_card.dart';
import '../../domain/entities/ticket_stat.dart';
import '../../domain/entities/tickets_content.dart';

/// Dua kartu statistik: podium musim ini (pink) dan ring digital (lime).
class TicketStatsRow extends StatelessWidget {
  const TicketStatsRow({super.key, required this.stats});

  final TicketStats stats;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Expanded(
            child: _StatCard(
              stat: stats.podium,
              tone: AppTones.pink,
              icon: Icons.military_tech_rounded,
            ),
          ),
          Expanded(
            child: _StatCard(
              stat: stats.ring,
              tone: AppTones.lime,
              icon: Icons.verified_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat, required this.tone, required this.icon});

  final TicketStat stat;
  final PastelTone tone;
  final IconData icon;

  static const double _iconCircle = 32;

  @override
  Widget build(BuildContext context) {
    return ToneCard(
      tone: tone,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Container(
            width: _iconCircle,
            height: _iconCircle,
            decoration: BoxDecoration(
              color: tone.foreground.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: tone.foreground),
          ),
          const SizedBox(height: 4),
          Text(
            stat.headline,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            stat.label,
            style: AppTextStyles.label.copyWith(color: tone.foreground),
          ),
          Text(
            stat.note,
            style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
