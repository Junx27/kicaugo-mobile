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
import '../widgets/login_form.dart';
import '../widgets/social_sign_in.dart';

/// Halaman masuk dengan email atau nomor WhatsApp.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      hero: const AuthHero(
        eyebrow: AuthStrings.loginEyebrow,
        title: AuthStrings.loginTitle,
        description: AuthStrings.loginDescription,
        chips: [
          IconPill(
            icon: Icons.bolt_rounded,
            iconColor: AppColors.onYellow,
            backgroundColor: AppColors.yellow,
            label: AuthStrings.chipActiveContests,
          ),
          IconPill(
            icon: Icons.confirmation_number_rounded,
            label: AuthStrings.chipInstantTicket,
          ),
        ],
      ),
      panel: [
        BlocSelector<AuthBloc, AuthState, bool>(
          selector: (state) => state.status == AuthStatus.authenticating,
          builder: (context, isLoading) => LoginForm(
            isLoading: isLoading,
            onSubmit: (identifier, password) => context.read<AuthBloc>().add(
              LoginSubmitted(identifier: identifier, password: password),
            ),
          ),
        ),
        const SocialSignIn(
          dividerLabel: AuthStrings.loginSocialDivider,
          buttonLabel: AuthStrings.loginGoogle,
        ),
      ],
      trustTone: AppTones.yellow,
      footer: const AuthSwitchLink(
        question: AuthStrings.noAccount,
        action: AuthStrings.toRegister,
        route: AppRoutes.register,
      ),
    );
  }
}
