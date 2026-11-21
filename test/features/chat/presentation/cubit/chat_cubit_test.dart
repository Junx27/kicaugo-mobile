import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/chat/domain/usecases/get_chat_sessions.dart';
import 'package:rumahkicau_mobile/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rumahkicau_mobile/features/chat/presentation/cubit/chat_state.dart';

import '../../support.dart';

void main() {
  const loaded = ChatState(
    status: ChatStatus.success,
    sessions: demoChatSessions,
  );

  blocTest<ChatCubit, ChatState>(
    'memuat sesi lalu success',
    build: () => ChatCubit(instantChatSessions),
    act: (cubit) => cubit.load(),
    expect: () => const [ChatState(status: ChatStatus.loading), loaded],
  );

  blocTest<ChatCubit, ChatState>(
    'memancarkan failure saat pemuatan gagal',
    build: () => ChatCubit(GetChatSessions(FlakyChatRepository())),
    act: (cubit) => cubit.load(),
    expect: () => const [
      ChatState(status: ChatStatus.loading),
      ChatState(status: ChatStatus.failure, message: 'Gagal memuat pesan'),
    ],
  );

  blocTest<ChatCubit, ChatState>(
    'kata kunci pencarian masuk ke state',
    build: () => ChatCubit(instantChatSessions),
    seed: () => loaded,
    act: (cubit) => cubit.search('kroto'),
    expect: () => [loaded.copyWith(query: 'kroto')],
  );

  blocTest<ChatCubit, ChatState>(
    'memilih filter kategori',
    build: () => ChatCubit(instantChatSessions),
    seed: () => loaded,
    act: (cubit) => cubit.selectFilter(ChatFilter.community),
    expect: () => [loaded.copyWith(filter: ChatFilter.community)],
  );

  test('filter dan pencarian menyaring sesi yang terlihat', () {
    expect(loaded.visibleSessions, hasLength(6));

    final organizer = loaded.copyWith(filter: ChatFilter.organizer);
    final community = loaded.copyWith(filter: ChatFilter.community);
    expect(organizer.visibleSessions, hasLength(3));
    expect(community.visibleSessions, hasLength(3));
    expect(community.visibleSessions.first.id, 'batavia-sf');

    final keyword = loaded.copyWith(query: '  MURAI  ');
    expect(keyword.visibleSessions, hasLength(2));
    expect(
      loaded.copyWith(query: 'kroto').visibleSessions.single.id,
      'batavia-sf',
    );

    final noMatch = loaded.copyWith(
      query: 'tidak-ada',
      filter: ChatFilter.community,
    );
    expect(noMatch.visibleSessions, isEmpty);
  });

  test('jumlah pesan belum dibaca dihitung dari seluruh sesi', () {
    expect(loaded.unreadCount, 5);
    expect(const ChatState(sessions: demoChatSessions).unreadCount, 5);
    expect(const ChatState().unreadCount, 0);
  });

  test('copyWith mempertahankan field yang tidak diubah', () {
    const failure = ChatState(
      status: ChatStatus.failure,
      sessions: demoChatSessions,
      query: 'murai',
      filter: ChatFilter.organizer,
      message: 'Gagal memuat pesan',
    );

    final changed = failure.copyWith(status: ChatStatus.success);

    expect(changed.status, ChatStatus.success);
    expect(changed.sessions, demoChatSessions);
    expect(changed.query, 'murai');
    expect(changed.filter, ChatFilter.organizer);
    expect(changed.message, 'Gagal memuat pesan');
  });
}
