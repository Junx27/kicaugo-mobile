import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Kartu tiket yang dibatalkan (refund).
class TicketHistoryRefundCard extends StatelessWidget {
  const TicketHistoryRefundCard({super.key, required this.onDownload});

  final ValueChanged<String> onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pink.withValues(alpha: 0.3),
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
                    Text(
                      '#INV-20250312-1109',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onPink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '12 Mar 2025 • Lapangan Raden Inten',
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
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.assignment_return_rounded,
                      size: 14,
                      color: AppColors.onPink,
                    ),
                    Text(
                      'Refund Selesai',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onPink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Latber Komunitas Jakarta Timur',
                  style: AppTextStyles.cardTitle,
                ),
                Text(
                  'Alasan Pembatalan: Burung Mabung Mendadak',
                  style: AppTextStyles.caption,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLavender,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kembali ke KicauPay:',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '+ Rp 50.000',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.onPink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => onDownload('Bukti_Refund_KicauPay_1109.pdf'),
            icon: const Icon(Icons.verified_user_rounded, size: 18),
            label: const Text('Lihat Bukti Refund Resmi'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onPink,
              side: const BorderSide(color: AppColors.pinkStrong),
              shape: const StadiumBorder(),
              minimumSize: const Size.fromHeight(44),
            ),
          ),
        ],
      ),
    );
  }
}
