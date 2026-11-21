import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../ticket_history_strings.dart';
import 'ticket_history_filter_pills.dart';

/// Sub-judul halaman: pulse dot, judul, deskripsi, filter.
class TicketHistorySubHeader extends StatelessWidget {
  const TicketHistorySubHeader({
    super.key,
    required this.filter,
    required this.onFilter,
  });

  final String filter;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  TicketHistoryStrings.title,
                  style: AppTextStyles.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(TicketHistoryStrings.subtitle, style: AppTextStyles.caption),
          const SizedBox(height: 12),
          TicketHistoryFilterPills(filter: filter, onFilter: onFilter),
        ],
      ),
    );
  }
}
