import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/community_content.dart';
import '../../domain/entities/community_topic.dart';
import '../../domain/usecases/get_community_content.dart';
import 'community_state.dart';

/// Memuat konten Komunitas dan menyimpan interaksi lokal pengguna.
class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit(this._getContent) : super(const CommunityState());

  final GetCommunityContent _getContent;

  Future<void> load() async {
    emit(_withStatus(CommunityStatus.loading));
    try {
      final content = await _getContent();
      emit(_withStatus(CommunityStatus.success, content: content));
    } on Failure catch (failure) {
      emit(_withStatus(CommunityStatus.failure, message: failure.message));
    }
  }

  void selectTopic(CommunityTopic topic) => emit(state.copyWith(topic: topic));

  void toggleJoin(String clubId) =>
      emit(state.copyWith(interactions: state.interactions.toggleJoin(clubId)));

  void toggleLike(String postId) =>
      emit(state.copyWith(interactions: state.interactions.toggleLike(postId)));

  void vote(int option) =>
      emit(state.copyWith(interactions: state.interactions.vote(option)));

  CommunityState _withStatus(
    CommunityStatus status, {
    CommunityContent? content,
    String? message,
  }) {
    return CommunityState(
      status: status,
      content: content,
      message: message,
      topic: state.topic,
      interactions: state.interactions,
    );
  }
}
