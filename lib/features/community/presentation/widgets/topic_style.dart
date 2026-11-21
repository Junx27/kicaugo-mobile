import '../../domain/entities/community_topic.dart';

/// Label chip per topik komunitas.
extension CommunityTopicStyle on CommunityTopic {
  String get label => switch (this) {
    CommunityTopic.all => 'Semua Topik',
    CommunityTopic.careTips => 'Tips Rawatan & EF',
    CommunityTopic.muraiBatu => 'Murai Batu Mania',
    CommunityTopic.kacerCucak => 'Kacer & Cucak Ijo',
    CommunityTopic.market => 'Bursa Burung Juara',
  };
}
