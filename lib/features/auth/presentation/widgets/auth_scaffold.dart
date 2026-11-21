import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'auth_header.dart';
import 'auth_trust_card.dart';

/// Kerangka bersama halaman masuk/daftar.
///
/// Menampilkan pesan gagal dari [AuthBloc] sebagai SnackBar. Perpindahan
/// halaman setelah berhasil ditangani redirect router.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.hero,
    required this.panel,
    required this.trustTone,
    required this.footer,
  });

  final Widget hero;

  /// Isi kartu putih (form dan tombol sosial).
  final List<Widget> panel;
  final PastelTone trustTone;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current.message != null && current.message != previous.message,
        listener: (context, state) => showAppSnackBar(context, state.message!),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(),
                const SizedBox(height: AppTheme.itemSpacing),
                hero,
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppTheme.panelRadius),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: panel,
                  ),
                ),
                const SizedBox(height: 14),
                AuthTrustCard(tone: trustTone),
                const SizedBox(height: 20),
                footer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
