import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
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

/// Repository yang gagal selama [fail] bernilai true.
class ToggleFailureRepository extends FakeHomeRepository {
  ToggleFailureRepository({this.fail = true});

  bool fail;

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    fetchCalls++;
    if (fail) throw const DataFailure('Gagal memuat beranda');
    return content;
  }
}

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

/// Mengirim refresh dan menunggu sampai handler selesai.
Future<void> _requestRefresh(HomeBloc bloc) async {
  final completer = Completer<void>();
  bloc.add(HomeRefreshRequested(completer: completer));
  await completer.future;
}

void main() {
  late FakeHomeRepository homeRepository;
  late FakeCurrentLocationRepository locationRepository;
  late ToggleFailureRepository toggleRepository;
  late FakeHomeRepository transientRepository;

  HomeBloc buildBloc({
    HomeRepository? repository,
    LocationService? locationService,
    FakeCurrentLocationRepository? locationSink,
    Duration loadTimeout = const Duration(milliseconds: 20),
  }) {
    return HomeBloc(
      GetHomeContent(repository ?? homeRepository),
      locationService: locationService ?? const NoLocationService(),
      updateCurrentLocation: UpdateCurrentLocation(
        locationSink ?? locationRepository,
      ),
      loadTimeout: loadTimeout,
      retryDelay: const Duration(milliseconds: 5),
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
  const fetchingLoaded = HomeState(
    status: HomeStatus.success,
    content: sampleHomeContent,
    isFetching: true,
  );
  const failureMessage = 'Gagal memuat beranda';
  const failureState = HomeState(
    status: HomeStatus.failure,
    message: failureMessage,
  );

  blocTest<HomeBloc, HomeState>(
    'memuat konten lalu success',
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
      loaded,
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'kegagalan terus-menerus berujung failure setelah batas waktu',
    build: () {
      toggleRepository = ToggleFailureRepository();
      return buildBloc(repository: toggleRepository);
    },
    act: (bloc) => bloc.add(const HomeStarted()),
    wait: const Duration(milliseconds: 60),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
      HomeState(
        status: HomeStatus.failure,
        message: AppConstants.homeLoadTimeout,
      ),
    ],
    verify: (bloc) {
      expect(toggleRepository.fetchCalls, greaterThan(1));
    },
  );

  blocTest<HomeBloc, HomeState>(
    'kegagalan sesaat pulih tanpa menghentikan shimmer',
    build: () {
      transientRepository = FakeHomeRepository(failuresRemaining: 1);
      return buildBloc(repository: transientRepository);
    },
    act: (bloc) => bloc.add(const HomeStarted()),
    wait: const Duration(milliseconds: 40),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
      loaded,
    ],
    verify: (bloc) {
      expect(transientRepository.fetchCalls, 2);
    },
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
      HomeState(
        status: HomeStatus.loading,
        categoryName: kacerName,
        isFetching: true,
      ),
      HomeState(
        status: HomeStatus.success,
        content: sampleHomeContent,
        categoryName: kacerName,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'refresh lewat gestur menampilkan shimmer dan menyelesaikan completer',
    build: buildBloc,
    seed: () => loaded.withCategoryName(kacerName),
    act: _requestRefresh,
    expect: () => const <HomeState>[
      HomeState(
        status: HomeStatus.success,
        content: sampleHomeContent,
        categoryName: kacerName,
        isFetching: true,
      ),
      HomeState(
        status: HomeStatus.success,
        content: sampleHomeContent,
        categoryName: kacerName,
      ),
    ],
    verify: (bloc) {
      expect(homeRepository.fetchCalls, 1);
      expect(bloc.state.status, HomeStatus.success);
      expect(bloc.state.categoryName, kacerName);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'refresh gagal mempertahankan konten dan tetap menyelesaikan completer',
    build: () {
      toggleRepository = ToggleFailureRepository();
      return buildBloc(repository: toggleRepository);
    },
    seed: () => loaded,
    act: _requestRefresh,
    expect: () => const <HomeState>[fetchingLoaded, loaded],
    verify: (bloc) {
      expect(toggleRepository.fetchCalls, 1);
      expect(bloc.state, loaded);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'refresh saat failure tidak menimpa error meski backend pulih',
    build: buildBloc,
    seed: () => failureState,
    act: _requestRefresh,
    expect: () => const <HomeState>[
      HomeState(
        status: HomeStatus.failure,
        message: failureMessage,
        isFetching: true,
      ),
      failureState,
    ],
    verify: (bloc) {
      expect(homeRepository.fetchCalls, 1);
      expect(bloc.state, failureState);
    },
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

  blocTest<HomeBloc, HomeState>(
    'timeout menampilkan failure dengan pesan batas waktu',
    build: () => buildBloc(
      repository: FakeHomeRepository(delay: const Duration(seconds: 1)),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    wait: const Duration(milliseconds: 60),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
      HomeState(
        status: HomeStatus.failure,
        message: AppConstants.homeLoadTimeout,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'refresh lokasi tidak menimpa failure akibat timeout',
    build: () {
      toggleRepository = ToggleFailureRepository();
      return buildBloc(
        repository: toggleRepository,
        locationService: FakeLocationService(location: sampleLocation),
      );
    },
    act: (bloc) => bloc.add(const HomeStarted()),
    wait: const Duration(milliseconds: 60),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
      HomeState(
        status: HomeStatus.failure,
        message: AppConstants.homeLoadTimeout,
      ),
    ],
    verify: (_) {
      expect(locationRepository.updates, <DeviceLocation>[sampleLocation]);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'retry setelah timeout berhasil memuat',
    build: () {
      toggleRepository = ToggleFailureRepository();
      return buildBloc(repository: toggleRepository);
    },
    act: (bloc) async {
      bloc.add(const HomeStarted());
      await Future<void>.delayed(const Duration(milliseconds: 40));
      toggleRepository.fail = false;
      bloc.add(const HomeRetryRequested());
    },
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
      HomeState(
        status: HomeStatus.failure,
        message: AppConstants.homeLoadTimeout,
      ),
      HomeState(status: HomeStatus.loading, isFetching: true),
      loaded,
    ],
  );

  test('kategori Semua menampilkan seluruh jadwal, tanpa konten kosong', () {
    expect(
      loaded.visibleSchedules,
      hasLength(sampleHomeContent.schedules.length),
    );
    expect(const HomeState().visibleSchedules, isEmpty);
  });

  blocTest<HomeBloc, HomeState>(
    'lokasi tersedia dikirim lalu konten disegarkan tanpa shimmer kedua',
    build: () => buildBloc(
      locationService: FakeLocationService(location: sampleLocation),
    ),
    act: (bloc) => bloc.add(const HomeStarted()),
    wait: const Duration(milliseconds: 20),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
      loaded,
    ],
    verify: (bloc) {
      expect(locationRepository.updates, <DeviceLocation>[sampleLocation]);
      expect(homeRepository.fetchCalls, 2);
      expect(bloc.state.isFetching, isFalse);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'tanpa lokasi tidak mengirim apa pun dan tidak menyegarkan',
    build: buildBloc,
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const <HomeState>[
      HomeState(status: HomeStatus.loading, isFetching: true),
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
      HomeState(status: HomeStatus.loading, isFetching: true),
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
      HomeState(status: HomeStatus.loading, isFetching: true),
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
      HomeState(status: HomeStatus.loading, isFetching: true),
      loaded,
    ],
  );
}
