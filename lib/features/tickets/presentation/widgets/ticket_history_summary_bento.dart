import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../ticket_history_strings.dart';

/// Dua kartu bento: total transaksi & tiket siap.
class TicketHistorySummaryBento extends StatelessWidget {
  const TicketHistorySummaryBento({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 12,
      children: [
        Expanded(child: _TotalCard()),
        Expanded(child: _ActiveCard()),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(AppTheme.badgeRadius),
                ),
                child: Text('2025', style: AppTextStyles.caption),
              ),
            ],
          ),
          Text(
            TicketHistoryStrings.totalTransactions.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          Text(TicketHistoryStrings.totalAmount, style: AppTextStyles.title),
          Row(
            spacing: 6,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                TicketHistoryStrings.totalEvents,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveCard extends StatelessWidget {
  const _ActiveCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
                ),
                child: const Icon(
                  Icons.confirmation_number_rounded,
                  color: AppColors.onLime,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.limeStrong,
                  borderRadius: BorderRadius.circular(AppTheme.badgeRadius),
                ),
                child: Text(
                  'Aktif',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onLime,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Text(
            TicketHistoryStrings.activeTickets.toUpperCase(),
            style: AppTextStyles.eyebrow.copyWith(color: AppColors.onLime),
          ),
          Text(TicketHistoryStrings.activeCount, style: AppTextStyles.title),
          Text(
            TicketHistoryStrings.activeEvents,
            style: AppTextStyles.caption.copyWith(color: AppColors.onLime),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
