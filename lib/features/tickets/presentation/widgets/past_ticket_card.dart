import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/link_button.dart';
import '../../domain/entities/past_ticket.dart';
import '../tickets_strings.dart';
import 'ticket_bits.dart';

/// Kartu tiket selesai (hasil + skor) atau dibatalkan (chip pink).
class PastTicketCard extends StatelessWidget {
  const PastTicketCard({super.key, required this.ticket});

  final PastTicket ticket;

  @override
  Widget build(BuildContext context) {
    final result = ticket.result;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(child: _Summary(ticket: ticket)),
              Flexible(child: _StatusChip(result: result)),
            ],
          ),
          if (result != null) _ScoreRow(score: result.score),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.ticket});

  final PastTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(ticket.detail, style: AppTextStyles.caption),
        Text(
          ticket.title,
          style: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
        ),
        Text(ticket.className, style: AppTextStyles.caption),
      ],
    );
  }
}

/// Hasil lomba berlatar lime (selesai/berhasil), atau "Dibatalkan" berlatar
/// pink bila tiket tidak punya hasil.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.result});

  final TicketResult? result;

  @override
  Widget build(BuildContext context) {
    final label = result?.label;
    if (label == null) {
      return const TicketChip(
        label: TicketsStrings.cancelled,
        background: AppColors.pink,
        foreground: AppColors.onPink,
        icon: Icons.cancel_rounded,
      );
    }
    return TicketChip(
      label: label,
      background: AppColors.lime,
      foreground: AppColors.onLime,
      icon: Icons.workspace_premium_rounded,
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.score});

  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lavenderTintStart,
        borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              const Icon(
                Icons.analytics_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              Text(
                score,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          LinkButton(
            label: TicketsStrings.certificate,
            trailingIcon: Icons.download_rounded,
            style: AppTextStyles.label,
            onPressed: () => showComingSoon(context),
          ),
        ],
      ),
    );
  }
}
