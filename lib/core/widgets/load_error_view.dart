import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

/// Pesan gagal memuat data dengan tombol coba lagi.
class LoadErrorView extends StatelessWidget {
  const LoadErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  static const double _buttonWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppTheme.itemSpacing,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: AppColors.textSecondary,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            SizedBox(
              width: _buttonWidth,
              child: AppButton(
                label: AppConstants.retryLabel,
                variant: AppButtonVariant.outlined,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
