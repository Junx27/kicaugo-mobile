import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/chat/domain/entities/chat_session.dart';
import 'package:rumahkicau_mobile/features/chat/domain/repositories/chat_repository.dart';
import 'package:rumahkicau_mobile/features/chat/domain/usecases/get_chat_sessions.dart';
import 'package:rumahkicau_mobile/features/chat/presentation/chat_strings.dart';
import 'package:rumahkicau_mobile/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rumahkicau_mobile/features/chat/presentation/pages/chat_page.dart';

import '../../support.dart';

/// Repository yang menunggu [completer] untuk menguji state loading.
class _PendingChatRepository implements ChatRepository {
  _PendingChatRepository(this.completer);

  final Completer<List<ChatSession>> completer;

  @override
  Future<List<ChatSession>> fetchSessions() => completer.future;
}

/// Memasang halaman chat dengan Cubit mandiri, seperti yang dibuat shell.
Future<void> _pumpChat(
  WidgetTester tester, {
  GetChatSessions getSessions = instantChatSessions,
  Size size = const Size(420, 3600),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: BlocProvider<ChatCubit>(
          create: (context) => ChatCubit(getSessions)..load(),
          child: const ChatPage(),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(find.byKey(const Key('chat_search_input')), query);
  await tester.pump();
}

/// Nilai opasitas FAB, dipakai untuk menguji visibilitas saat scroll.
double _composeOpacity(WidgetTester tester) => tester
    .widget<AnimatedOpacity>(
      find.ancestor(
        of: find.byKey(const Key('chat_compose')),
        matching: find.byType(AnimatedOpacity),
      ),
    )
    .opacity;

void main() {
  testWidgets('menampilkan loading lalu daftar sesi', (tester) async {
    final completer = Completer<List<ChatSession>>();
    await _pumpChat(
      tester,
      getSessions: GetChatSessions(_PendingChatRepository(completer)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(demoChatSessions);
    await tester.pump();

    expect(find.byKey(const Key('chat_session_piala-raja')), findsOneWidget);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpChat(
      tester,
      getSessions: GetChatSessions(FlakyChatRepository()),
    );
    expect(find.text('Gagal memuat pesan'), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('chat_session_piala-raja')), findsOneWidget);
  });

  testWidgets('menampilkan seluruh bagian dan enam sesi chat', (tester) async {
    await _pumpChat(tester);

    expect(find.text(ChatStrings.searchHint), findsOneWidget);
    expect(find.text(ChatStrings.filterAll), findsOneWidget);
    // Label filter juga dipakai badge kategori pada kartu sesi.
    expect(find.text(ChatStrings.filterOrganizer), findsNWidgets(3));
    expect(find.text(ChatStrings.filterCommunity), findsNWidgets(4));
    for (final session in demoChatSessions) {
      expect(find.text(session.title), findsOneWidget);
      expect(find.byKey(Key('chat_session_${session.id}')), findsOneWidget);
    }
    expect(find.text(ChatStrings.online), findsOneWidget);
    expect(find.text('24 anggota'), findsOneWidget);
    expect(find.text(ChatStrings.badgeSupport), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pencarian menyaring lalu menampilkan empty state', (
    tester,
  ) async {
    await _pumpChat(tester);

    await _search(tester, 'kroto');
    expect(find.byKey(const Key('chat_session_batavia-sf')), findsOneWidget);
    expect(find.byKey(const Key('chat_session_piala-raja')), findsNothing);
    expect(find.byKey(const Key('chat_empty_state')), findsNothing);

    await _search(tester, 'tidak-ada');
    expect(find.byKey(const Key('chat_empty_state')), findsOneWidget);
    expect(find.text(ChatStrings.emptyTitle), findsOneWidget);
    expect(find.text(ChatStrings.emptyHint), findsOneWidget);
    expect(find.byKey(const Key('chat_session_batavia-sf')), findsNothing);

    await _search(tester, '');
    expect(find.byKey(const Key('chat_empty_state')), findsNothing);
    expect(find.byKey(const Key('chat_session_piala-raja')), findsOneWidget);
  });

  testWidgets('filter pilihan menyaring daftar sesi', (tester) async {
    await _pumpChat(tester);

    await _tapKey(tester, 'chat_filter_organizer');
    expect(find.byKey(const Key('chat_session_piala-raja')), findsOneWidget);
    expect(find.byKey(const Key('chat_session_batavia-sf')), findsNothing);

    await _tapKey(tester, 'chat_filter_community');
    expect(find.byKey(const Key('chat_session_batavia-sf')), findsOneWidget);
    expect(find.byKey(const Key('chat_session_piala-raja')), findsNothing);

    await _tapKey(tester, 'chat_filter_all');
    expect(find.byKey(const Key('chat_session_piala-raja')), findsOneWidget);
    expect(find.byKey(const Key('chat_session_batavia-sf')), findsOneWidget);
  });

  testWidgets(
    'FAB hilang saat scroll ke bawah dan muncul saat scroll ke atas',
    (tester) async {
      await _pumpChat(tester, size: const Size(420, 800));
      final list = find.ancestor(
        of: find.byKey(const Key('chat_session_piala-raja')),
        matching: find.byType(ListView),
      );
      const settle = Duration(milliseconds: 300);

      expect(_composeOpacity(tester), 1);

      await tester.drag(list, const Offset(0, -400));
      await tester.pump(settle);
      expect(_composeOpacity(tester), 0);

      await tester.drag(list, const Offset(0, 300));
      await tester.pump(settle);
      expect(_composeOpacity(tester), 1);

      await tester.drag(list, const Offset(0, -300));
      await tester.pump(settle);
      expect(_composeOpacity(tester), 0);
    },
  );

  final comingSoonTargets = <String, String>{
    'kartu sesi': 'chat_session_piala-raja',
    'tombol tulis pesan': 'chat_compose',
  };
  comingSoonTargets.forEach((name, key) {
    testWidgets('$name menampilkan segera hadir', (tester) async {
      await _pumpChat(tester);

      await _tapKey(tester, key);

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  });
}
