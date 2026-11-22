import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_content.dart';
import 'package:rumahkicau_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_state.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/update_current_location.dart';

import '../../../../support/fakes.dart';

const String kacerName = 'Kacer';
const String kenariName = 'Kenari';
const DeviceLocation sampleLocation = DeviceLocation(
  latitude: -6.2,
  longitude: 106.8,
  accuracyM: 12,
);

/// Repository yang hanya gagal pada pemanggilan kedua (refresh pasca lokasi).
class FailOnRefreshRepository extends FakeHomeRepository {
  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    fetchCalls++;
    if (fetchCalls > 1) throw const DataFailure('Gagal menyegarkan');
    return content;
  }
}

void main() {
  late FakeHomeRepository homeRepository;
  late FakeCurrentLocationRepository locationRepository;

  HomeBloc buildBloc({
    HomeRepository? repository,
    LocationService? locationService,
    FakeCurrentLocationRepository? locationSink,
  }) {
    return HomeBloc(
      GetHomeContent(repository ?? homeRepository),
      locationService: locationService ?? const NoLocationService(),
      updateCurrentLocation: UpdateCurrentLocation(
        locationSink ?? locationRepository,
      ),
    );
  }

  setUp(() {
    homeRepository = FakeHomeRepository();
    locationRepository = FakeCurrentLocationRepository();
  });

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
    build: () =>
        buildBloc(repository: FakeHomeRepository(failuresRemaining: 1)),
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
      categoryName: kacerName,
    ),
    act: (bloc) => bloc.add(const HomeRetryRequested()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, categoryName: kacerName),
      HomeState(
        status: HomeStatus.success,
        content: sampleHomeContent,
        categoryName: kacerName,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'memilih kategori menyaring jadwal populer',
    build: buildBloc,
    seed: () => loaded,
    act: (bloc) => bloc.add(const HomeCategorySelected(kenariName)),
    expect: () => [loaded.withCategoryName(kenariName)],
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

  blocTest<HomeBloc, HomeState>(
    'lokasi tersedia dikirim lalu konten disegarkan tanpa loading',
    build: () => buildBloc(
      locationService: FakeLocationService(location: sampleLocation),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    wait: const Duration(milliseconds: 20),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading),
      loaded,
    ],
    verify: (_) {
      expect(locationRepository.updates, <DeviceLocation>[sampleLocation]);
      expect(homeRepository.fetchCalls, 2);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'tanpa lokasi tidak mengirim apa pun dan tidak menyegarkan',
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading),
      loaded,
    ],
    verify: (_) {
      expect(locationRepository.updates, isEmpty);
      expect(homeRepository.fetchCalls, 1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'gagal membaca lokasi tidak menggagalkan beranda',
    build: () => buildBloc(
      locationService: FakeLocationService(error: StateError('GPS mati')),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading),
      loaded,
    ],
    verify: (_) => expect(locationRepository.updates, isEmpty),
  );

  blocTest<HomeBloc, HomeState>(
    'gagal mengirim lokasi tidak menggagalkan beranda',
    build: () => buildBloc(
      locationService: FakeLocationService(location: sampleLocation),
      locationSink: FakeCurrentLocationRepository(
        error: const DataFailure('Gagal menyimpan'),
      ),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading),
      loaded,
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'gagal menyegarkan setelah lokasi mempertahankan konten sukses',
    build: () => buildBloc(
      repository: FailOnRefreshRepository(),
      locationService: FakeLocationService(location: sampleLocation),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading),
      loaded,
    ],
  );
}
