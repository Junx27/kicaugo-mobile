import 'package:equatable/equatable.dart';

import '../../domain/entities/bird_club.dart';
import '../../domain/entities/community_content.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/community_topic.dart';

/// Status pemuatan tab Komunitas.
enum CommunityStatus { initial, loading, success, failure }

/// Interaksi lokal pengguna: klub yang diikuti, postingan disukai, pilihan
/// polling. Belum disimpan ke server.
class CommunityInteractions extends Equatable {
  const CommunityInteractions({
    this.joinedClubIds = const <String>{},
    this.likedPostIds = const <String>{},
    this.pollChoice,
  });

  final Set<String> joinedClubIds;
  final Set<String> likedPostIds;
  final int? pollChoice;

  CommunityInteractions toggleJoin(String clubId) => CommunityInteractions(
    joinedClubIds: _toggled(joinedClubIds, clubId),
    likedPostIds: likedPostIds,
    pollChoice: pollChoice,
  );

  CommunityInteractions toggleLike(String postId) => CommunityInteractions(
    joinedClubIds: joinedClubIds,
    likedPostIds: _toggled(likedPostIds, postId),
    pollChoice: pollChoice,
  );

  CommunityInteractions vote(int option) => CommunityInteractions(
    joinedClubIds: joinedClubIds,
    likedPostIds: likedPostIds,
    pollChoice: option,
  );

  static Set<String> _toggled(Set<String> ids, String id) {
    final next = Set<String>.of(ids);
    if (!next.remove(id)) {
      next.add(id);
    }
    return next;
  }

  @override
  List<Object?> get props => [joinedClubIds, likedPostIds, pollChoice];
}

/// State yang dibaca halaman Komunitas.
class CommunityState extends Equatable {
  const CommunityState({
    this.status = CommunityStatus.initial,
    this.content,
    this.message,
    this.topic = CommunityTopic.all,
    this.interactions = const CommunityInteractions(),
  });

  final CommunityStatus status;
  final CommunityContent? content;
  final String? message;
  final CommunityTopic topic;
  final CommunityInteractions interactions;

  /// Obrolan sesuai topik terpilih.
  List<CommunityPost> get visiblePosts {
    final posts = content?.posts ?? const <CommunityPost>[];
    if (topic == CommunityTopic.all) {
      return posts;
    }
    return posts.where((post) => post.topic == topic).toList();
  }

  bool isJoined(BirdClub club) => interactions.joinedClubIds.contains(club.id);

  int memberCount(BirdClub club) => club.members + (isJoined(club) ? 1 : 0);

  bool isLiked(CommunityPost post) =>
      interactions.likedPostIds.contains(post.id);

  int likeCount(CommunityPost post) =>
      post.counts.likes + (isLiked(post) ? 1 : 0);

  /// Jumlah suara pilihan [index], termasuk suara pengguna.
  int pollVotes(int index) {
    final base = content?.poll.options[index].votes ?? 0;
    return base + (interactions.pollChoice == index ? 1 : 0);
  }

  /// Total suara polling, termasuk suara pengguna.
  int get pollTotal {
    final options = content?.poll.options ?? const [];
    final base = options.fold<int>(0, (sum, option) => sum + option.votes);
    return base + (interactions.pollChoice == null ? 0 : 1);
  }

  /// Persentase pilihan [index] dibulatkan (0 bila belum ada suara).
  int pollPercent(int index) {
    final total = pollTotal;
    if (total == 0) {
      return 0;
    }
    return (pollVotes(index) * 100 / total).round();
  }

  CommunityState copyWith({
    CommunityTopic? topic,
    CommunityInteractions? interactions,
  }) {
    return CommunityState(
      status: status,
      content: content,
      message: message,
      topic: topic ?? this.topic,
      interactions: interactions ?? this.interactions,
    );
  }

  @override
  List<Object?> get props => [status, content, message, topic, interactions];
}
