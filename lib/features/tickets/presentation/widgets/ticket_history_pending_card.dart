import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Kartu tiket yang masih menunggu paddock.
class TicketHistoryPendingCard extends StatelessWidget {
  const TicketHistoryPendingCard({
    super.key,
    required this.onShowQr,
    required this.onDownload,
  });

  final VoidCallback onShowQr;
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
                    Text('#INV-20250516-7712', style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(
                      '10 Mei 2025 • 14:15 WIB',
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
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      size: 14,
                      color: AppColors.onLime,
                    ),
                    Text(
                      'Menunggu Paddock',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onLime,
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.lavender,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: const Icon(
                    Icons.pets_rounded,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Batavia Cup Feat PBI Pusat',
                        style: AppTextStyles.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Murai Batu BOB 24G • Sesi 1',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nomor Gantangan Terundi:', style: AppTextStyles.caption),
              Text(
                'Gantangan No. 08',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Bayar (KicauPay)', style: AppTextStyles.caption),
                  Text('Rp 150.000', style: AppTextStyles.title),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(AppTheme.badgeRadius),
                ),
                child: Text('Lunas Instan', style: AppTextStyles.caption),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onShowQr,
                  icon: const Icon(Icons.qr_code_rounded, size: 16),
                  label: const Text('Lihat E-Tiket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onDownload('Bukti_Bayar_7712.pdf'),
                  icon: const Icon(Icons.receipt_rounded, size: 16),
                  label: const Text('Bukti Bayar'),
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
