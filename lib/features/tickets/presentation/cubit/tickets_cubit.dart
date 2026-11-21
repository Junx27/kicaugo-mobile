import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/bird_category.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_tickets_content.dart';
import 'tickets_state.dart';

/// Memuat tiket pengguna serta menyimpan tab dan filter burung terpilih.
class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit(this._getTickets) : super(const TicketsState());

  final GetTicketsContent _getTickets;

  Future<void> load() async {
    emit(state.copyWith(status: TicketsStatus.loading));
    try {
      final content = await _getTickets();
      emit(state.copyWith(status: TicketsStatus.success, content: content));
    } on Failure catch (failure) {
      emit(
        state.copyWith(status: TicketsStatus.failure, message: failure.message),
      );
    }
  }

  void selectTab(TicketsTab tab) => emit(state.copyWith(tab: tab));

  void selectCategory(BirdCategory category) =>
      emit(state.copyWith(category: category));
}
