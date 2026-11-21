import 'package:bloc_test/bloc_test.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/usecases/get_ticket_history_content.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/cubit/ticket_history_cubit.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/cubit/ticket_history_state.dart';

import '../../ticket_history_fakes.dart';

void main() {
  blocTest<TicketHistoryCubit, TicketHistoryState>(
    'memuat lalu success',
    build: () => TicketHistoryCubit(instantTicketHistory),
    act: (cubit) => cubit.load(),
    expect: () => [
      const TicketHistoryState(status: TicketHistoryStatus.loading),
      const TicketHistoryState(
        status: TicketHistoryStatus.success,
        content: demoTicketHistory,
      ),
    ],
  );

  blocTest<TicketHistoryCubit, TicketHistoryState>(
    'gagal memuat lalu message',
    build: () => TicketHistoryCubit(
      GetTicketHistoryContent(
        FlakyTicketHistoryRepository(failuresRemaining: 1),
      ),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      const TicketHistoryState(status: TicketHistoryStatus.loading),
      const TicketHistoryState(
        status: TicketHistoryStatus.failure,
        message: 'Gagal memuat riwayat tiket',
      ),
    ],
  );
}
