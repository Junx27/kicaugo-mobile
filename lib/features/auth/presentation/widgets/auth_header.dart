import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/brand_badge.dart';
import '../auth_strings.dart';

/// Header halaman auth: logo KicauGo dan tombol "Butuh Bantuan?".
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8,
      children: [
        const Flexible(child: BrandBadge()),
        TextButton.icon(
          onPressed: () => showComingSoon(context),
          style: AppTheme.softPillButton(
            foreground: AppColors.textSecondary,
            textStyle: AppTextStyles.label,
          ),
          icon: const Icon(Icons.support_agent_rounded, size: 16),
          label: const Text(AuthStrings.help),
        ),
      ],
    );
  }
}
