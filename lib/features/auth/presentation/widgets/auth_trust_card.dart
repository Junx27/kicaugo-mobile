import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../auth_strings.dart';

/// Kartu kecil "Jaminan Keamanan" dengan latar pastel [tone].
class AuthTrustCard extends StatelessWidget {
  const AuthTrustCard({super.key, required this.tone});

  final PastelTone tone;

  static const double _iconBoxSize = 36;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone.light.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: _iconBoxSize,
            height: _iconBoxSize,
            decoration: BoxDecoration(
              color: tone.light,
              borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
              boxShadow: AppTheme.softShadow,
            ),
            child: Icon(Icons.verified_user_rounded, color: tone.foreground),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthStrings.trustTitle,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  AuthStrings.trustBody,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
