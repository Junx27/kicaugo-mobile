import '../../domain/entities/chat_session.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);

  final ChatDataSource _dataSource;

  @override
  Future<List<ChatSession>> fetchSessions() => _dataSource.fetchSessions();
}
