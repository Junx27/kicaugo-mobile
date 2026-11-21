import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../ticket_history_strings.dart';

/// Baris filter horizontal (Semua / Lunas / Selesai / Refund).
class TicketHistoryFilterPills extends StatelessWidget {
  const TicketHistoryFilterPills({
    super.key,
    required this.filter,
    required this.onFilter,
  });

  final String filter;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          _FilterPill(
            label: TicketHistoryStrings.filterAll,
            selected: filter == 'all',
            onTap: () => onFilter('all'),
          ),
          _FilterPill(
            label: TicketHistoryStrings.filterReady,
            selected: filter == 'ready',
            onTap: () => onFilter('ready'),
          ),
          _FilterPill(
            label: TicketHistoryStrings.filterCompleted,
            selected: filter == 'completed',
            onTap: () => onFilter('completed'),
          ),
          _FilterPill(
            key: const Key('ticket_history_filter_refund'),
            label: TicketHistoryStrings.filterRefund,
            selected: filter == 'refund',
            onTap: () => onFilter('refund'),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceLavender,
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          boxShadow: selected ? AppTheme.raisedShadow : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: selected ? AppColors.surface : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
