import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/chat/data/datasources/fake_chat_data_source.dart';
import 'package:rumahkicau_mobile/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:rumahkicau_mobile/features/chat/domain/entities/chat_session.dart';
import 'package:rumahkicau_mobile/features/chat/domain/repositories/chat_repository.dart';
import 'package:rumahkicau_mobile/features/chat/domain/usecases/get_chat_sessions.dart';

/// Data sesi demo yang dipakai seluruh test fitur chat.
const List<ChatSession> demoChatSessions = FakeChatDataSource.sessions;

/// Usecase chat demo tanpa jeda.
const GetChatSessions instantChatSessions = GetChatSessions(
  ChatRepositoryImpl(FakeChatDataSource(delay: Duration.zero)),
);

/// Repository chat yang gagal sejumlah [failuresRemaining] kali.
class FlakyChatRepository implements ChatRepository {
  FlakyChatRepository({this.failuresRemaining = 1});

  int failuresRemaining;

  @override
  Future<List<ChatSession>> fetchSessions() async {
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure('Gagal memuat pesan');
    }
    return demoChatSessions;
  }
}
