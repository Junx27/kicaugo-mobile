import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_contest_detail.dart';
import 'contest_detail_state.dart';

/// Cubit untuk memuat detail lomba berdasarkan id.
class ContestDetailCubit extends Cubit<ContestDetailState> {
  ContestDetailCubit(this._getContestDetail, {this.id})
    : super(const ContestDetailState());

  final GetContestDetail _getContestDetail;
  final int? id;

  Future<void> load([int? contestId]) async {
    final targetId = contestId ?? id;
    if (targetId == null) {
      emit(
        const ContestDetailState(
          status: ContestDetailStatus.failure,
          message: 'ID lomba tidak tersedia.',
        ),
      );
      return;
    }
    emit(const ContestDetailState(status: ContestDetailStatus.loading));
    try {
      final detail = await _getContestDetail(targetId);
      emit(
        ContestDetailState(status: ContestDetailStatus.success, detail: detail),
      );
    } on Failure catch (failure) {
      emit(
        ContestDetailState(
          status: ContestDetailStatus.failure,
          message: failure.message,
        ),
      );
    }
  }
}
