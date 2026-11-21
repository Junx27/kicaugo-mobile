import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/chat/data/datasources/chat_data_source.dart';
import 'package:rumahkicau_mobile/features/chat/data/datasources/fake_chat_data_source.dart';
import 'package:rumahkicau_mobile/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:rumahkicau_mobile/features/chat/domain/entities/chat_session.dart';

import '../support.dart';

/// Sumber data pencatat pemanggilan untuk menguji forwarding repository.
class _RecordingChatDataSource implements ChatDataSource {
  int calls = 0;

  @override
  Future<List<ChatSession>> fetchSessions() async {
    calls++;
    return demoChatSessions;
  }
}

void main() {
  test('sumber data demo mengembalikan enam sesi chat', () async {
    final sessions = await const FakeChatDataSource(
      delay: Duration.zero,
    ).fetchSessions();

    expect(sessions, demoChatSessions);
    expect(sessions, hasLength(6));
    expect(
      sessions.where((item) => item.category == ChatCategory.organizer),
      hasLength(3),
    );
    expect(
      sessions.where((item) => item.category == ChatCategory.community),
      hasLength(3),
    );
    expect(sessions.fold<int>(0, (sum, item) => sum + item.unread), 5);
  });

  test('repository meneruskan permintaan ke sumber data', () async {
    final dataSource = _RecordingChatDataSource();

    final sessions = await ChatRepositoryImpl(dataSource).fetchSessions();

    expect(dataSource.calls, 1);
    expect(sessions, demoChatSessions);
  });

  test('usecase meneruskan data dari repository', () async {
    final sessions = await instantChatSessions();

    expect(sessions.first.title, 'Piala Raja Nusantara');
    expect(sessions.last.title, 'Forum Murai Batu Nusantara');
  });

  test('entity mengekspos seluruh field lewat props', () {
    final session = demoChatSessions.first;

    expect(session.props, hasLength(11));
    expect(session.support, isFalse);
    expect(session.verified, isTrue);
    expect(demoChatSessions.first == demoChatSessions.last, isFalse);
  });
}
