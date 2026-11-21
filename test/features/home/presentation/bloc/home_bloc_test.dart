import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_state.dart';

import '../../../../support/fakes.dart';

void main() {
  HomeBloc buildBloc([FakeHomeRepository? repository]) =>
      HomeBloc(GetHomeContent(repository ?? FakeHomeRepository()));

  const loaded = HomeState(
    status: HomeStatus.success,
    content: sampleHomeContent,
  );

  blocTest<HomeBloc, HomeState>(
    'memuat konten lalu success',
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading),
      loaded,
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'memancarkan failure saat pemuatan gagal',
    build: () => buildBloc(FakeHomeRepository(failuresRemaining: 1)),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading),
      HomeState(status: HomeStatus.failure, message: 'Gagal memuat beranda'),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'retry mempertahankan kategori terpilih',
    build: buildBloc,
    seed: () => const HomeState(
      status: HomeStatus.failure,
      message: 'Gagal',
      category: BirdCategory.kacer,
    ),
    act: (bloc) => bloc.add(const HomeRetryRequested()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, category: BirdCategory.kacer),
      HomeState(
        status: HomeStatus.success,
        content: sampleHomeContent,
        category: BirdCategory.kacer,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'memilih kategori menyaring jadwal populer',
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(const HomeCategorySelected(BirdCategory.kenari)),
    expect: () => [loaded.withCategory(BirdCategory.kenari)],
    verify: (bloc) {
      expect(bloc.state.visibleSchedules, hasLength(1));
      expect(bloc.state.visibleSchedules.single.category, BirdCategory.kenari);
    },
  );

  test('kategori Semua menampilkan seluruh jadwal, tanpa konten kosong', () {
    expect(
      loaded.visibleSchedules,
      hasLength(sampleHomeContent.schedules.length),
    );
    expect(const HomeState().visibleSchedules, isEmpty);
  });
}
