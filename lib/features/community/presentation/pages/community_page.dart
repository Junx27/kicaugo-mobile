import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../data/datasources/fake_community_data_source.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../domain/entities/community_content.dart';
import '../../domain/usecases/get_community_content.dart';
import '../cubit/community_cubit.dart';
import '../cubit/community_state.dart';
import '../widgets/club_section.dart';
import '../widgets/community_search_field.dart';
import '../widgets/create_post_fab.dart';
import '../widgets/poll_card.dart';
import '../widgets/post_feed.dart';
import '../widgets/topic_chips.dart';
import '../widgets/trending_card.dart';

/// Tab Komunitas: bird club, diskusi, polling, dan obrolan terbaru.
///
/// [getCommunityContent] default memakai data demo; ganti saat API tersedia.
class CommunityPage extends StatelessWidget {
  const CommunityPage({
    super.key,
    this.getCommunityContent = const GetCommunityContent(
      CommunityRepositoryImpl(FakeCommunityDataSource()),
    ),
  });

  final GetCommunityContent getCommunityContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityCubit(getCommunityContent)..load(),
      child: const _CommunityView(),
    );
  }
}

class _CommunityView extends StatelessWidget {
  const _CommunityView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, bottom: false,
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<CommunityCubit, CommunityState>(
              builder: (context, state) => switch (state.status) {
                CommunityStatus.initial || CommunityStatus.loading =>
                  const Center(child: CircularProgressIndicator()),
                CommunityStatus.failure => LoadErrorView(
                  message: state.message ?? AppConstants.homeLoadError,
                  onRetry: () => context.read<CommunityCubit>().load(),
                ),
                CommunityStatus.success => _CommunityBody(
                  content: state.content!,
                  state: state,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityBody extends StatelessWidget {
  const _CommunityBody({required this.content, required this.state});

  final CommunityContent content;
  final CommunityState state;

  /// Ruang bawah agar FAB dan navigasi mengambang tidak menutupi konten.
  static const double _bottomInset = 180;

  /// Jarak FAB dari bawah: di atas navigasi pill (64 + margin).
  static const double _fabBottom = 92;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CommunityCubit>();
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, _bottomInset),
          children: [
            const CommunitySearchField(),
            const SizedBox(height: 12),
            TopicChips(selected: state.topic, onSelected: cubit.selectTopic),
            const SizedBox(height: 20),
            ClubSection(
              clubs: content.clubs,
              isJoined: state.isJoined,
              memberCount: state.memberCount,
              onToggleJoin: (club) => cubit.toggleJoin(club.id),
            ),
            const SizedBox(height: 20),
            TrendingCard(discussion: content.trending),
            const SizedBox(height: 20),
            PollCard(
              poll: content.poll,
              tally: (
                choice: state.interactions.pollChoice,
                total: state.pollTotal,
                percentOf: state.pollPercent,
              ),
              onVote: cubit.vote,
            ),
            const SizedBox(height: 24),
            PostFeed(
              posts: state.visiblePosts,
              likeOf: (post) =>
                  (liked: state.isLiked(post), count: state.likeCount(post)),
              onToggleLike: (post) => cubit.toggleLike(post.id),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: _fabBottom + MediaQuery.paddingOf(context).bottom,
          child: const CreatePostFab(),
        ),
      ],
    );
  }
}
