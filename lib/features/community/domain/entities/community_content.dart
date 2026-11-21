import 'package:equatable/equatable.dart';

import 'bird_club.dart';
import 'community_poll.dart';
import 'community_post.dart';
import 'trending_discussion.dart';

/// Seluruh data tab Komunitas.
class CommunityContent extends Equatable {
  const CommunityContent({
    required this.clubs,
    required this.trending,
    required this.poll,
    required this.posts,
  });

  final List<BirdClub> clubs;
  final TrendingDiscussion trending;
  final CommunityPoll poll;
  final List<CommunityPost> posts;

  @override
  List<Object?> get props => [clubs, trending, poll, posts];
}
