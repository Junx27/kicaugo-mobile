import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../auth_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_hero.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/register_form.dart';
import '../widgets/social_sign_in.dart';

/// Halaman daftar akun; berhasil daftar langsung membuat sesi.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      hero: const AuthHero(
        eyebrow: AuthStrings.registerEyebrow,
        title: AuthStrings.registerTitle,
        description: AuthStrings.registerDescription,
        chips: [
          IconPill(
            icon: Icons.celebration_rounded,
            iconColor: AppColors.onLime,
            backgroundColor: AppColors.lime,
            label: AuthStrings.chipFreeSignUp,
          ),
          IconPill(
            icon: Icons.qr_code_2_rounded,
            label: AuthStrings.chipQrTicket,
          ),
        ],
      ),
      panel: [
        BlocSelector<AuthBloc, AuthState, bool>(
          selector: (state) => state.status == AuthStatus.authenticating,
          builder: (context, isLoading) => RegisterForm(
            isLoading: isLoading,
            onSubmit: (name, identifier, password) =>
                context.read<AuthBloc>().add(
                  RegisterSubmitted(
                    name: name,
                    identifier: identifier,
                    password: password,
                  ),
                ),
          ),
        ),
        const SocialSignIn(
          dividerLabel: AuthStrings.registerSocialDivider,
          buttonLabel: AuthStrings.registerGoogle,
        ),
      ],
      trustTone: AppTones.lime,
      footer: const AuthSwitchLink(
        question: AuthStrings.haveAccount,
        action: AuthStrings.toLogin,
        route: AppRoutes.login,
      ),
    );
  }
}
