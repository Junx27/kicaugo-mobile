import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';

/// Pemisah "atau ... dengan" dan tombol Google (belum tersedia).
class SocialSignIn extends StatelessWidget {
  const SocialSignIn({
    super.key,
    required this.dividerLabel,
    required this.buttonLabel,
  });

  final String dividerLabel;
  final String buttonLabel;

  static const double _logoSize = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Row(
          spacing: 12,
          children: [
            const Expanded(child: Divider()),
            Text(dividerLabel, style: AppTextStyles.caption),
            const Expanded(child: Divider()),
          ],
        ),
        TextButton(
          onPressed: () => showComingSoon(context),
          style: TextButton.styleFrom(
            backgroundColor: AppColors.inputFill,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size.fromHeight(AppTheme.buttonHeight),
            shape: const StadiumBorder(),
            textStyle: AppTextStyles.label,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              SvgPicture.asset(
                AppConstants.googleLogoAsset,
                width: _logoSize,
                height: _logoSize,
              ),
              Text(buttonLabel),
            ],
          ),
        ),
      ],
    );
  }
}
