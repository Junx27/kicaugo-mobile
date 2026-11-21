import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/link_button.dart';

/// Baris bawah "Belum punya akun? Daftar" / "Sudah punya akun? Masuk".
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.question,
    required this.action,
    required this.route,
  });

  final String question;
  final String action;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        Text(
          question,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        LinkButton(
          label: action,
          style: AppTextStyles.button,
          onPressed: () => context.go(route),
        ),
      ],
    );
  }
}
