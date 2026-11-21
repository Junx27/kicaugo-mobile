import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_ticket_history_content.dart';
import 'ticket_history_state.dart';

class TicketHistoryCubit extends Cubit<TicketHistoryState> {
  TicketHistoryCubit(this._getContent) : super(const TicketHistoryState());

  final GetTicketHistoryContent _getContent;

  Future<void> load() async {
    emit(const TicketHistoryState(status: TicketHistoryStatus.loading));
    try {
      final content = await _getContent();
      emit(
        TicketHistoryState(
          status: TicketHistoryStatus.success,
          content: content,
        ),
      );
    } on Failure catch (failure) {
      emit(
        TicketHistoryState(
          status: TicketHistoryStatus.failure,
          message: failure.message,
        ),
      );
    }
  }
}
