import '../../domain/entities/chat_session.dart';

abstract class ChatDataSource {
  Future<List<ChatSession>> fetchSessions();
}
