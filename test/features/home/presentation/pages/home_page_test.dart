import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_content.dart';
import 'package:rumahkicau_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_event.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/home_page.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/category_chips.dart';

import '../../../../support/fakes.dart';
import '../../../../support/pump_app.dart';

const _profileMarker = 'profil-test';
final _morning = DateTime(2026, 11, 20, 8);
const _content = sampleHomeContent;

/// Memasang Beranda di layar tinggi agar seluruh isi daftar ter-render.
Future<void> _pumpHome(
  WidgetTester tester, {
  HomeRepository? repository,
  bool signedIn = false,
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
  final homeBloc = HomeBloc(GetHomeContent(repository ?? FakeHomeRepository()))
    ..add(const HomeStarted());
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
  await tester.pump();
}

void main() {
  testWidgets('menampilkan loading selama data dimuat', (tester) async {
    final completer = Completer<HomeContent>();
    await _pumpHome(tester, repository: CompleterHomeRepository(completer));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Selesaikan di dalam zona test agar bloc bisa ditutup saat teardown.
    completer.complete(sampleHomeContent);
    await tester.pump();
    expect(find.text(_content.featured.title), findsOneWidget);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpHome(
      tester,
      repository: FakeHomeRepository(failuresRemaining: 1),
    );
    expect(find.text('Gagal memuat beranda'), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(_content.featured.title), findsOneWidget);
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
    'cari': () => find.text(HomeStrings.searchHint),
    'filter': () => find.byTooltip(HomeStrings.filterTooltip),
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
