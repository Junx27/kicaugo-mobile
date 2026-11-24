import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_content.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_profile.dart';
import 'package:rumahkicau_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/home_page.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/category_chips.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/home_skeleton.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/update_current_location.dart';

import '../../../../support/fakes.dart';
import '../../../../support/pump_app.dart';

const _profileMarker = 'profil-test';
final _morning = DateTime(2026, 11, 20, 8);
const _content = sampleHomeContent;

HomeContent _contentWithProfile(HomeProfile profile) => HomeContent(
  profile: profile,
  featured: _content.featured,
  upcoming: _content.upcoming,
  stats: _content.stats,
  activeTicket: _content.activeTicket,
  schedules: _content.schedules,
  categories: _content.categories,
);

/// Memasang Beranda di layar tinggi agar seluruh isi daftar ter-render.
Future<void> _pumpHome(
  WidgetTester tester, {
  HomeRepository? repository,
  bool signedIn = false,
  Duration loadTimeout = AppConstants.homeShimmerTimeout,
  Duration retryDelay = AppConstants.homeRetryDelay,
}) async {
  tester.view.physicalSize = const Size(420, 2800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final authBloc = createAuthBloc();
  addTearDown(authBloc.close);
  if (signedIn) {
    authBloc.add(
      const RegisterSubmitted(
        name: 'Sari',
        identifier: demoIdentifier,
        password: demoPassword,
      ),
    );
    await authBloc.stream.firstWhere((state) => state.isAuthenticated);
  }
  final homeBloc = HomeBloc(
    GetHomeContent(repository ?? FakeHomeRepository()),
    locationService: const NoLocationService(),
    updateCurrentLocation: UpdateCurrentLocation(
      FakeCurrentLocationRepository(),
    ),
    loadTimeout: loadTimeout,
    retryDelay: retryDelay,
  )..add(const HomeStarted());
  addTearDown(homeBloc.close);

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) =>
            Scaffold(body: HomePage(clock: () => _morning)),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const Text(_profileMarker),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: homeBloc),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pump();
}

/// Menggeser pita kategori sampai chip [label] terlihat, lalu mengetuknya.
Future<void> _tapChip(WidgetTester tester, String label) async {
  await tester.dragUntilVisible(
    find.text(label),
    find.byType(CategoryChips),
    const Offset(-120, 0),
  );
  // Tunggu sisa animasi geser agar ketukan tidak hanya menghentikan scroll.
  await pumpNavigation(tester);
  await tester.tap(find.text(label));
  // Tunggu animasi reorder chip dan scroll ke pangkal selesai.
  await tester.pump(const Duration(milliseconds: 300));
}

/// Repository yang menunggu [gate] pada setiap percobaan.
class _GatedRepository implements HomeRepository {
  _GatedRepository(this.gate);

  final Completer<void> gate;
  int calls = 0;

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    calls++;
    await gate.future;
    return _content;
  }
}

/// Repository yang gagal selama [fail] bernilai true.
class _ToggleFailureRepository implements HomeRepository {
  bool fail = true;
  int calls = 0;

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    calls++;
    if (fail) throw const DataFailure('Gagal memuat beranda');
    return _content;
  }
}

void main() {
  testWidgets('menampilkan loading selama data dimuat', (tester) async {
    final completer = Completer<HomeContent>();
    await _pumpHome(tester, repository: CompleterHomeRepository(completer));

    expect(find.byType(HomeSkeleton), findsOneWidget);

    // Selesaikan di dalam zona test agar bloc bisa ditutup saat teardown.
    completer.complete(sampleHomeContent);
    await tester.pump();
    expect(find.text(_content.featured.title), findsOneWidget);
  });

  testWidgets(
    'refresh lewat RefreshIndicator menyegarkan tanpa mengganti konten',
    (tester) async {
      final repository = FakeHomeRepository();
      await _pumpHome(tester, repository: repository);

      expect(find.byType(RefreshIndicator), findsOneWidget);

      final indicator = tester.widget<RefreshIndicator>(
        find.byType(RefreshIndicator),
      );
      await indicator.onRefresh();
      await tester.pump();

      expect(repository.fetchCalls, greaterThan(1));
      expect(find.byType(HomeSkeleton), findsNothing);
      expect(find.text(_content.featured.title), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('refresh menampilkan shimmer selama backend mengambil data', (
    tester,
  ) async {
    final repository = FakeHomeRepository(
      delay: const Duration(milliseconds: 200),
    );
    await _pumpHome(tester, repository: repository);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();

    expect(find.byType(HomeSkeleton), findsNothing);

    final indicator = tester.widget<RefreshIndicator>(
      find.byType(RefreshIndicator),
    );
    final pending = indicator.onRefresh();
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(HomeSkeleton), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 250));
    await pending;
    await tester.pump();

    expect(find.byType(HomeSkeleton), findsNothing);
    expect(find.text(_content.featured.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('timeout shimmer menampilkan tombol coba lalu sukses', (
    tester,
  ) async {
    final gate = Completer<void>();
    addTearDown(() {
      if (!gate.isCompleted) gate.complete();
    });

    await _pumpHome(
      tester,
      repository: _GatedRepository(gate),
      loadTimeout: const Duration(milliseconds: 20),
      retryDelay: const Duration(milliseconds: 5),
    );

    await tester.pump(const Duration(milliseconds: 40));
    await tester.pump();

    expect(find.text(AppConstants.homeLoadTimeout), findsOneWidget);
    expect(find.text(AppConstants.retryLabel), findsOneWidget);

    gate.complete();
    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(_content.featured.title), findsOneWidget);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    final repository = _ToggleFailureRepository();
    await _pumpHome(
      tester,
      repository: repository,
      loadTimeout: const Duration(milliseconds: 20),
      retryDelay: const Duration(milliseconds: 5),
    );

    await tester.pump(const Duration(milliseconds: 40));
    await tester.pump();

    expect(find.text(AppConstants.homeLoadTimeout), findsOneWidget);
    expect(find.text(AppConstants.retryLabel), findsOneWidget);
    expect(repository.calls, greaterThan(1));

    repository.fail = false;
    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(_content.featured.title), findsOneWidget);
  });

  testWidgets('kegagalan sesaat pulih tanpa menampilkan tombol coba lagi', (
    tester,
  ) async {
    final repository = FakeHomeRepository(failuresRemaining: 1);
    await _pumpHome(
      tester,
      repository: repository,
      loadTimeout: const Duration(milliseconds: 20),
      retryDelay: const Duration(milliseconds: 5),
    );

    await tester.pump(const Duration(milliseconds: 40));
    await tester.pump();

    expect(find.byType(HomeSkeleton), findsNothing);
    expect(find.text(AppConstants.retryLabel), findsNothing);
    expect(find.text(_content.featured.title), findsOneWidget);
    expect(repository.fetchCalls, 2);
  });

  testWidgets('menampilkan seluruh bagian Beranda', (tester) async {
    await _pumpHome(tester);

    expect(find.text('Selamat Pagi'), findsOneWidget);
    expect(find.text('Halo, ${HomeStrings.fallbackName} 👋'), findsOneWidget);
    expect(find.text('14 ${HomeStrings.liveSuffix}'), findsOneWidget);
    expect(find.text(_content.featured.title), findsOneWidget);
    expect(find.text('+48'), findsOneWidget);
    expect(find.text('SISA 3 TIKET'), findsOneWidget);
    expect(find.text(_content.stats.headline), findsOneWidget);
    expect(find.text(_content.activeTicket.event), findsOneWidget);
    for (final item in _content.schedules) {
      expect(find.text(item.title), findsOneWidget);
    }
    expect(find.text(HomeStrings.communityTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sapaan memakai nama pengguna yang masuk', (tester) async {
    await _pumpHome(tester, signedIn: true);

    expect(find.text('Halo, Sari 👋'), findsOneWidget);
  });

  testWidgets('sapaan dan nama memakai profil dari API bila tersedia', (
    tester,
  ) async {
    await _pumpHome(
      tester,
      repository: FakeHomeRepository(
        content: _contentWithProfile(
          const HomeProfile(
            name: 'Nama API',
            greeting: 'Sapaan API',
            liveCount: 3,
          ),
        ),
      ),
    );

    expect(find.text('Sapaan API'), findsOneWidget);
    expect(find.text('Halo, Nama API 👋'), findsOneWidget);
  });

  testWidgets('chip kategori menyaring jadwal, Lovebird kosong', (
    tester,
  ) async {
    await _pumpHome(tester);

    await _tapChip(tester, 'Kenari');
    expect(find.text('Kenari Cup Kemang'), findsOneWidget);
    expect(find.text('Festival Kicau Batavia'), findsNothing);

    await _tapChip(tester, 'Lovebird');
    expect(find.text(HomeStrings.emptySchedules), findsOneWidget);
  });

  final comingSoonTargets = <String, Finder Function()>{
    'detail': () => find.text(HomeStrings.seeDetail),
    'e-tiket': () => find.text(HomeStrings.openTicket),
    'lihat semua': () => find.text(HomeStrings.seeAll),
    'pesan': () => find.text(HomeStrings.book).first,
    'komunitas': () => find.text(HomeStrings.communityTitle),
  };
  comingSoonTargets.forEach((name, finder) {
    testWidgets('$name menampilkan segera hadir', (tester) async {
      await _pumpHome(tester);

      await tester.tap(finder());
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  });
}
