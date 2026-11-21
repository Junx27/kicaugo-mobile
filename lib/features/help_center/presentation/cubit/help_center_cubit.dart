import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_help_center_content.dart';
import 'help_center_state.dart';

/// Memuat konten, memfilter FAQ, dan mengatur accordion.
class HelpCenterCubit extends Cubit<HelpCenterState> {
  HelpCenterCubit(this._getHelpCenterContent) : super(const HelpCenterState());

  final GetHelpCenterContent _getHelpCenterContent;

  Future<void> load() async {
    emit(state.copyWith(status: HelpCenterStatus.loading));
    try {
      final content = await _getHelpCenterContent();
      emit(state.copyWith(status: HelpCenterStatus.success, content: content));
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: HelpCenterStatus.failure,
          message: failure.message,
        ),
      );
    }
  }

  /// Memfilter FAQ berdasarkan pertanyaan dan jawaban.
  void search(String query) {
    emit(state.copyWith(query: query, clearExpandedFaq: true));
  }

  /// Membuka FAQ yang dipilih dan menutup FAQ lain.
  void toggleFaq(String faqId) {
    final isExpanded = state.expandedFaqId == faqId;
    emit(
      state.copyWith(
        expandedFaqId: isExpanded ? null : faqId,
        clearExpandedFaq: isExpanded,
      ),
    );
  }
}
