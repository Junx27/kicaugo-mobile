import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../ticket_history_strings.dart';

/// Catatan faktur pajak + tombol rekap bulanan.
class TicketHistoryInfoNote extends StatelessWidget {
  const TicketHistoryInfoNote({super.key, required this.onDownload});

  final ValueChanged<String> onDownload;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLavender,
            borderRadius: BorderRadius.circular(AppTheme.panelRadius),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help_center_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TicketHistoryStrings.taxHelpTitle,
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      TicketHistoryStrings.taxHelpBody,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => onDownload('Rekap_Transaksi_KicauGo_2025.zip'),
          icon: const Icon(Icons.archive_rounded, size: 18),
          label: const Text(TicketHistoryStrings.monthlyRecap),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.lavender),
            shape: const StadiumBorder(),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    );
  }
}
