import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Kartu tiket aktif (siap scan QR).
class TicketHistoryActiveCard extends StatelessWidget {
  const TicketHistoryActiveCard({
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        border: const Border(
          left: BorderSide(color: AppColors.primary, width: 4),
        ),
        boxShadow: AppTheme.softShadow,
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
                      '#INV-20250518-8821',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '14 Mei 2025 • 09:30 WIB',
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
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 14,
                      color: AppColors.surface,
                    ),
                    Text(
                      'Siap Scan QR',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.surface,
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
              color: AppColors.surfaceLavender,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.lavender,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lime,
                          borderRadius: BorderRadius.circular(
                            AppTheme.badgeRadius,
                          ),
                        ),
                        child: Text(
                          'PBI Nasional',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.onLime,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Piala Raja Nusantara 2025',
                        style: AppTextStyles.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Murai Batu Utama • Sesi 3',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLavender.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gacoan Terdaftar', style: AppTextStyles.caption),
                      Text(
                        'Halilintar (Ring PBI 8891)',
                        style: AppTextStyles.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Posisi Gantangan', style: AppTextStyles.caption),
                    Text(
                      'Gantangan No. 24',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Pembayaran', style: AppTextStyles.caption),
                  Text('Rp 750.000', style: AppTextStyles.title),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: AppColors.onLime,
                  ),
                  Text('QRIS Dinamis', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onShowQr,
                  icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                  label: const Text('Lihat E-Tiket QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onDownload('Invoice_PialaRaja_8821.pdf'),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Invoice PDF'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
