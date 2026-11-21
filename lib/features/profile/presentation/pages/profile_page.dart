import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/fake_profile_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_content.dart';
import '../../domain/usecases/get_profile_content.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../profile_strings.dart';
import '../widgets/profile_bird_section.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_services_section.dart';
import '../widgets/profile_settings_section.dart';
import '../widgets/profile_stats_grid.dart';

/// Tab Profil: identitas anggota, statistik, amunisi, layanan, dan keluar.
///
/// [getProfileContent] memakai data demo secara default dan dapat diganti saat
/// test atau ketika sumber data API tersedia.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.getProfileContent = const GetProfileContent(
      ProfileRepositoryImpl(FakeProfileDataSource()),
    ),
  });

  final GetProfileContent getProfileContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(getProfileContent)..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceLavender,
      child: SafeArea(
        top: false, bottom: false,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) => switch (state.status) {
                  ProfileStatus.initial || ProfileStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  ProfileStatus.failure => LoadErrorView(
                    message: state.message ?? AppConstants.homeLoadError,
                    onRetry: () => context.read<ProfileCubit>().load(),
                  ),
                  ProfileStatus.success => _ProfileContentView(
                    content: state.content!,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContentView extends StatelessWidget {
  const _ProfileContentView({required this.content});

  final ProfileContent content;

  /// Ruang bawah agar konten terakhir tidak tertutup navigasi mengambang.
  static const double _bottomInset = 112;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, _bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocSelector<AuthBloc, AuthState, String>(
            selector: (state) =>
                state.user?.name ?? ProfileStrings.fallbackName,
            builder: (context, name) =>
                ProfileHeaderCard(member: content.member, name: name),
          ),
          const SizedBox(height: 16),
          ProfileStatsGrid(stats: content.stats),
          const SizedBox(height: 24),
          ProfileBirdSection(birds: content.birds),
          const SizedBox(height: 24),
          const ProfileServicesSection(),
          const SizedBox(height: 24),
          ProfileSettingsSection(
            onHelp: () => context.push(AppRoutes.helpCenter),
            onReminders: () => context.push(AppRoutes.reminders),
            onTicketInvoices: () => context.push(AppRoutes.ticketHistory),
            onLogout: () =>
                context.read<AuthBloc>().add(const LogoutRequested()),
          ),
        ],
      ),
    );
  }
}
