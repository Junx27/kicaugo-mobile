import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/community/data/datasources/fake_community_data_source.dart';
import 'package:rumahkicau_mobile/features/community/domain/entities/community_topic.dart';

void main() {
  test('mengembalikan konten demo Komunitas', () async {
    final content = await const FakeCommunityDataSource(
      delay: Duration.zero,
    ).fetchCommunityContent();

    expect(content, FakeCommunityDataSource.content);
    expect(content.clubs, hasLength(3));
    expect(content.poll.options, hasLength(3));
  });

  test('data demo tidak memakai nama organisasi nyata', () {
    const content = FakeCommunityDataSource.content;
    final texts = [
      ...content.clubs.map((club) => club.name),
      content.trending.title,
      content.trending.author,
      content.trending.quote,
      ...content.posts.map((post) => post.body),
    ];

    for (final text in texts) {
      expect(text.contains('PBI'), isFalse, reason: text);
      expect(text.contains('BnR'), isFalse, reason: text);
    }
  });

  test('topik Bursa tidak punya obrolan agar keadaan kosong teruji', () {
    expect(
      FakeCommunityDataSource.content.posts.where(
        (post) => post.topic == CommunityTopic.market,
      ),
      isEmpty,
    );
  });
}
