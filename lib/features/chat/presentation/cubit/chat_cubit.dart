import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';

import '../../domain/usecases/get_chat_sessions.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._getSessions) : super(const ChatState());

  final GetChatSessions _getSessions;

  Future<void> load() async {
    emit(const ChatState(status: ChatStatus.loading));
    try {
      final sessions = await _getSessions();
      emit(ChatState(status: ChatStatus.success, sessions: sessions));
    } on Failure catch (failure) {
      emit(ChatState(status: ChatStatus.failure, message: failure.message));
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void selectFilter(ChatFilter filter) => emit(state.copyWith(filter: filter));
}
