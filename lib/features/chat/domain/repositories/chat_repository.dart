import '../entities/chat_session.dart';

abstract class ChatRepository {
  Future<List<ChatSession>> fetchSessions();
}
