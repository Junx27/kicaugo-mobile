import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/usecases/get_tickets_content.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/cubit/tickets_state.dart';

import '../../support.dart';

void main() {
  const loaded = TicketsState(
    status: TicketsStatus.success,
    content: demoTickets,
  );

  blocTest<TicketsCubit, TicketsState>(
    'memuat tiket lalu success',
    build: () => TicketsCubit(instantTickets),
    act: (cubit) => cubit.load(),
    expect: () => const [TicketsState(status: TicketsStatus.loading), loaded],
  );

  blocTest<TicketsCubit, TicketsState>(
    'memancarkan failure saat pemuatan gagal',
    build: () => TicketsCubit(GetTicketsContent(FlakyTicketsRepository())),
    act: (cubit) => cubit.load(),
    expect: () => const [
      TicketsState(status: TicketsStatus.loading),
      TicketsState(
        status: TicketsStatus.failure,
        message: 'Gagal memuat tiket',
      ),
    ],
  );

  blocTest<TicketsCubit, TicketsState>(
    'memilih tab dan kategori',
    build: () => TicketsCubit(instantTickets),
    seed: () => loaded,
    act: (cubit) => cubit
      ..selectTab(TicketsTab.history)
      ..selectCategory(BirdCategory.kacer),
    expect: () => [
      loaded.copyWith(tab: TicketsTab.history),
      loaded.copyWith(tab: TicketsTab.history, category: BirdCategory.kacer),
    ],
  );

  test('filter kategori menyaring setiap daftar tiket', () {
    final kacer = loaded.copyWith(category: BirdCategory.kacer);
    final cucak = loaded.copyWith(category: BirdCategory.cucakHijau);

    expect(loaded.visibleUpcoming, hasLength(2));
    expect(kacer.visibleUpcoming.single.seat.number, '#G-09');
    expect(kacer.visibleHistory, hasLength(1));
    expect(kacer.visibleCancelled, isEmpty);
    expect(cucak.visibleCancelled, hasLength(1));
  });

  test('jumlah per tab tanpa konten bernilai nol', () {
    const empty = TicketsState();

    for (final tab in TicketsTab.values) {
      expect(empty.countFor(tab), 0);
      expect(loaded.countFor(tab), isPositive);
    }
    expect(empty.visibleHistory, isEmpty);
  });
}
