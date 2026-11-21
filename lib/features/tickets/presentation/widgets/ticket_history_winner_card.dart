import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';

/// Kartu tiket selesai dengan status juara.
class TicketHistoryWinnerCard extends StatelessWidget {
  const TicketHistoryWinnerCard({super.key, required this.onDownload});

  final ValueChanged<String> onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#INV-20250420-5541', style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(
                      '20 Apr 2025 • Gelora Gantangan Batavia',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Text(
                  'Juara 1 🏆',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onYellow,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Latpres Ramadhan Ceria Batavia SF',
                  style: AppTextStyles.cardTitle,
                ),
                Text(
                  'Kacer BOB 36G • Gacoan: Black Phantom',
                  style: AppTextStyles.caption,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLavender,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nominal Tiket (BCA VA)',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        'Rp 100.000',
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => showComingSoon(context),
                  icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                  label: const Text('Cetak Piagam'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.onLime,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onDownload('Invoice_BataviaSF_5541.pdf'),
                  icon: const Icon(Icons.receipt_long_rounded, size: 18),
                  label: const Text('Rincian Invoice'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
