import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/greeting.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/home_content.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../home_strings.dart';
import '../widgets/active_ticket_card.dart';
import '../widgets/category_chips.dart';
import '../widgets/community_banner.dart';
import '../widgets/featured_contest_card.dart';
import '../widgets/home_greeting.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/home_stats_card.dart';
import '../widgets/popular_schedule_list.dart';
import '../widgets/upcoming_contest_card.dart';

/// Penyedia waktu, bisa diganti saat test agar sapaan deterministik.
typedef Clock = DateTime Function();

/// Memicu refresh latar dan menunggu sampai percobaan selesai.
Future<void> _refreshHome(BuildContext context) {
  final completer = Completer<void>();
  context.read<HomeBloc>().add(HomeRefreshRequested(completer: completer));
  return completer.future;
}

/// Beranda. [HomeBloc] disediakan oleh shell agar badge navigasi ikut membaca.
class HomePage extends StatelessWidget {
  const HomePage({super.key, this.clock = DateTime.now});

  final Clock clock;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final content = state.content;
          if (content == null) {
            return switch (state.status) {
              HomeStatus.failure => LoadErrorView(
                message: state.message ?? AppConstants.homeLoadError,
                onRetry: () =>
                    context.read<HomeBloc>().add(const HomeRetryRequested()),
              ),
              _ => const HomeSkeleton(),
            };
          }
          return _HomeContentView(
            content: content,
            state: state,
            greeting: greetingFor(clock()),
            showSkeleton: state.isFetching,
          );
        },
      ),
    );
  }
}

class _HomeContentView extends StatelessWidget {
  const _HomeContentView({
    required this.content,
    required this.state,
    required this.greeting,
    required this.showSkeleton,
  });

  final HomeContent content;
  final HomeState state;
  final String greeting;
  final bool showSkeleton;

  /// Ruang bawah agar konten terakhir tidak tertutup navigasi mengambang.
  static const double _bottomInset = 112;
  static const EdgeInsets _gutter = EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshHome(context),
            child: Stack(
              children: [
                ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    bottom: _bottomInset,
                  ),
                  children: [
                    Padding(
                      padding: _gutter,
                      child: Column(
                        spacing: 12,
                        children: [
                          BlocSelector<AuthBloc, AuthState, String>(
                            selector: (auth) =>
                                auth.user?.name ?? HomeStrings.fallbackName,
                            builder: (context, name) => HomeGreeting(
                              greeting: content.profile.greeting.isNotEmpty
                                  ? content.profile.greeting
                                  : greeting,
                              name: content.profile.name.isNotEmpty
                                  ? content.profile.name
                                  : name,
                              liveCount: content.profile.liveCount,
                              avatarUrl: content.profile.avatarUrl,
                            ),
                          ),
                          const HomeSearchBar(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    CategoryChips(
                      categories: content.categories,
                      selectedName: state.categoryName,
                      onSelected: (name) => context.read<HomeBloc>().add(
                        HomeCategorySelected(name),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: _gutter,
                      child: _HomeCards(content: content, state: state),
                    ),
                  ],
                ),
                if (showSkeleton)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: Theme.of(context).colorScheme.surface,
                        child: const HomeSkeleton(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeCards extends StatelessWidget {
  const _HomeCards({required this.content, required this.state});

  final HomeContent content;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        FeaturedContestCard(contest: content.featured),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Expanded(child: UpcomingContestCard(contest: content.upcoming)),
              Expanded(child: HomeStatsCard(stats: content.stats)),
            ],
          ),
        ),
        ActiveTicketCard(ticket: content.activeTicket),
        PopularScheduleList(items: state.visibleSchedules),
        const CommunityBanner(),
      ],
    );
  }
}
