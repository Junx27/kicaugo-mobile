import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/community/domain/entities/community_topic.dart';
import 'package:rumahkicau_mobile/features/community/domain/usecases/get_community_content.dart';
import 'package:rumahkicau_mobile/features/community/presentation/cubit/community_cubit.dart';
import 'package:rumahkicau_mobile/features/community/presentation/cubit/community_state.dart';

import '../../support/community_fakes.dart';

void main() {
  CommunityCubit buildCubit([FakeCommunityRepository? repository]) =>
      CommunityCubit(
        GetCommunityContent(repository ?? FakeCommunityRepository()),
      );

  const loaded = CommunityState(
    status: CommunityStatus.success,
    content: sampleCommunity,
  );
  final club = sampleCommunity.clubs.first;
  final post = sampleCommunity.posts.first;

  blocTest<CommunityCubit, CommunityState>(
    'memuat konten lalu success',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => const [
      CommunityState(status: CommunityStatus.loading),
      loaded,
    ],
  );

  blocTest<CommunityCubit, CommunityState>(
    'gagal memuat menyimpan pesan dan mempertahankan topik',
    build: () => buildCubit(FakeCommunityRepository(failuresRemaining: 1)),
    seed: () => const CommunityState(topic: CommunityTopic.market),
    act: (cubit) => cubit.load(),
    expect: () => const [
      CommunityState(
        status: CommunityStatus.loading,
        topic: CommunityTopic.market,
      ),
      CommunityState(
        status: CommunityStatus.failure,
        message: communityFailure,
        topic: CommunityTopic.market,
      ),
    ],
  );

  blocTest<CommunityCubit, CommunityState>(
    'memilih topik menyaring obrolan',
    build: buildCubit,
    seed: () => loaded,
    act: (cubit) => cubit.selectTopic(CommunityTopic.kacerCucak),
    verify: (cubit) {
      expect(cubit.state.visiblePosts, hasLength(1));
      expect(cubit.state.visiblePosts.single.topic, CommunityTopic.kacerCucak);
    },
  );

  blocTest<CommunityCubit, CommunityState>(
    'gabung lalu batal gabung klub mengubah jumlah anggota',
    build: buildCubit,
    seed: () => loaded,
    act: (cubit) {
      cubit.toggleJoin(club.id);
      expect(cubit.state.isJoined(club), isTrue);
      expect(cubit.state.memberCount(club), club.members + 1);
      cubit.toggleJoin(club.id);
    },
    verify: (cubit) {
      expect(cubit.state.isJoined(club), isFalse);
      expect(cubit.state.memberCount(club), club.members);
    },
  );

  blocTest<CommunityCubit, CommunityState>(
    'suka lalu batal suka mengubah hitungan',
    build: buildCubit,
    seed: () => loaded,
    act: (cubit) {
      cubit.toggleLike(post.id);
      expect(cubit.state.likeCount(post), post.counts.likes + 1);
      cubit.toggleLike(post.id);
    },
    verify: (cubit) {
      expect(cubit.state.isLiked(post), isFalse);
      expect(cubit.state.likeCount(post), post.counts.likes);
    },
  );

  blocTest<CommunityCubit, CommunityState>(
    'memilih polling menambah satu suara dan bisa berganti pilihan',
    build: buildCubit,
    seed: () => loaded,
    act: (cubit) {
      expect(cubit.state.pollTotal, 1420);
      expect(cubit.state.pollPercent(0), 62);
      cubit.vote(2);
      expect(cubit.state.pollTotal, 1421);
      expect(cubit.state.pollVotes(2), 143);
      cubit.vote(0);
    },
    verify: (cubit) {
      expect(cubit.state.interactions.pollChoice, 0);
      expect(cubit.state.pollVotes(0), 881);
      expect(cubit.state.pollVotes(2), 142);
      expect(cubit.state.pollTotal, 1421);
    },
  );

  test('state tanpa konten aman dibaca', () {
    const state = CommunityState();

    expect(state.visiblePosts, isEmpty);
    expect(state.pollTotal, 0);
    expect(state.pollPercent(0), 0);
  });
}
