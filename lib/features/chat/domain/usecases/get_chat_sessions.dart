import '../entities/chat_session.dart';
import '../repositories/chat_repository.dart';

class GetChatSessions {
  const GetChatSessions(this._repository);

  final ChatRepository _repository;

  Future<List<ChatSession>> call() => _repository.fetchSessions();
}
