import 'package:bloc_test/bloc_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/event/domain/usecases/get_contest_detail.dart';
import 'package:rumahkicau_mobile/features/event/presentation/bloc/contest_detail_cubit.dart';
import 'package:rumahkicau_mobile/features/event/presentation/bloc/contest_detail_state.dart';

import '../../support/contest_detail_fixture.dart';

void main() {
  blocTest<ContestDetailCubit, ContestDetailState>(
    'mengirim failure saat id tidak tersedia',
    build: () =>
        ContestDetailCubit(GetContestDetail(StubContestDetailRepository())),
    act: (cubit) => cubit.load(),
    expect: () => <ContestDetailState>[
      const ContestDetailState(
        status: ContestDetailStatus.failure,
        message: 'ID lomba tidak tersedia.',
      ),
    ],
  );

  blocTest<ContestDetailCubit, ContestDetailState>(
    'mengirim failure saat usecase melempar Failure',
    build: () => ContestDetailCubit(
      GetContestDetail(
        StubContestDetailRepository(
          error: const DataFailure('Gagal memuat detail'),
        ),
      ),
      id: 5,
    ),
    act: (cubit) => cubit.load(),
    expect: () => <ContestDetailState>[
      const ContestDetailState(status: ContestDetailStatus.loading),
      const ContestDetailState(
        status: ContestDetailStatus.failure,
        message: 'Gagal memuat detail',
      ),
    ],
  );
}
