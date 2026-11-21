import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_session.dart';

enum ChatStatus { initial, loading, success, failure }

enum ChatFilter { all, organizer, community }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.sessions = const <ChatSession>[],
    this.query = '',
    this.filter = ChatFilter.all,
    this.message,
  });

  final ChatStatus status;
  final List<ChatSession> sessions;
  final String query;
  final ChatFilter filter;
  final String? message;

  /// Hasil pencarian + filter dihitung, tidak disimpan sebagai field.
  List<ChatSession> get visibleSessions {
    final keyword = query.trim().toLowerCase();
    return sessions
        .where((session) {
          final matchFilter = switch (filter) {
            ChatFilter.all => true,
            ChatFilter.organizer => session.category == ChatCategory.organizer,
            ChatFilter.community => session.category == ChatCategory.community,
          };
          if (!matchFilter) return false;
          if (keyword.isEmpty) return true;
          return session.title.toLowerCase().contains(keyword) ||
              session.preview.toLowerCase().contains(keyword);
        })
        .toList(growable: false);
  }

  int get unreadCount =>
      sessions.fold<int>(0, (total, session) => total + session.unread);

  ChatState copyWith({
    ChatStatus? status,
    List<ChatSession>? sessions,
    String? query,
    ChatFilter? filter,
    String? message,
  }) {
    return ChatState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    sessions,
    query,
    filter,
    message,
  ];
}
