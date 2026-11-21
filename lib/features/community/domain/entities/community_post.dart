import 'package:equatable/equatable.dart';

import 'community_topic.dart';

/// Jumlah balasan dan suka sebuah postingan.
typedef PostCounts = ({int replies, int likes});

/// Penulis postingan: nama, inisial avatar, label klub, dan keterangan waktu.
class PostAuthor extends Equatable {
  const PostAuthor({
    required this.name,
    required this.initials,
    required this.tag,
    required this.meta,
  });

  final String name;
  final String initials;
  final String tag;
  final String meta;

  @override
  List<Object?> get props => [name, initials, tag, meta];
}

/// Satu obrolan pada feed komunitas.
class CommunityPost extends Equatable {
  const CommunityPost({
    required this.id,
    required this.author,
    required this.topic,
    required this.hashtag,
    required this.body,
    required this.counts,
    this.hasShowcase = false,
  });

  final String id;
  final PostAuthor author;
  final CommunityTopic topic;
  final String hashtag;
  final String body;
  final PostCounts counts;

  /// Postingan pamer hasil lomba (kartu pink dengan galeri).
  final bool hasShowcase;

  @override
  List<Object?> get props => [
    id,
    author,
    topic,
    hashtag,
    body,
    counts,
    hasShowcase,
  ];
}
