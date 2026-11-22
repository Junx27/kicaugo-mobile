import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/app.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/logging/app_logger.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/session_storage.dart';
import 'package:rumahkicau_mobile/features/auth/domain/entities/user.dart';
import 'package:rumahkicau_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:rumahkicau_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';

import 'fakes.dart';

export 'fakes.dart' show demoIdentifier, demoName, demoPassword;

/// Cukup untuk menyelesaikan transisi halaman dan animasi slide.
const Duration pageTransition = Duration(milliseconds: 600);

/// Teks penanda rute beranda pada router uji halaman auth.
const String homeMarker = 'beranda-test';

/// Sumber data Beranda demo tanpa jeda.
const HomeDemoDataSource instantHomeData = HomeDemoDataSource(
  delay: Duration.zero,
);

/// Usecase Beranda dengan data dummy produksi tanpa jeda.
GetHomeContent defaultGetHomeContent() {
  return const GetHomeContent(HomeRepositoryImpl(instantHomeData));
}

/// Membuat [AuthBloc] dari satu repository palsu.
AuthBloc createAuthBloc({
  AuthRepository? repository,
  SessionStorage? sessionStorage,
  User? initialUser,
}) {
  final authRepository = repository ?? FakeAuthRepository();
  return AuthBloc(
    login: LoginUseCase(authRepository),
    register: RegisterUseCase(authRepository),
    logout: LogoutUseCase(authRepository),
    sessionStorage: sessionStorage,
    initialUser: initialUser,
  );
}

/// Menjalankan aplikasi lengkap lalu melewati splash hingga onboarding tampil.
///
/// Splash dan onboarding punya animasi berulang, jadi helper ini memakai
/// `pump` berdurasi, bukan `pumpAndSettle`.
Future<AuthBloc> pumpKicauKuApp(
  WidgetTester tester, {
  AuthRepository? authRepository,
  HomeRepository? homeRepository,
  SessionStorage? sessionStorage,
}) async {
  AppLogger.enabled = false;
  final authBloc = createAuthBloc(
    repository: authRepository,
    sessionStorage: sessionStorage,
  );
  addTearDown(authBloc.close);
  final homeUseCase = GetHomeContent(
    homeRepository ?? const HomeRepositoryImpl(instantHomeData),
  );
  await tester.pumpWidget(
    KicauKuApp(authBloc: authBloc, getHomeContent: homeUseCase),
  );
  await tester.pump(AppConstants.splashDuration);
  await tester.pump(pageTransition);
  return authBloc;
}

/// Memasang halaman login/daftar dengan [AuthBloc] dan router minimal tanpa
/// redirect, sehingga test halaman tidak bergantung pada alur splash.
Future<AuthBloc> pumpAuthPage(
  WidgetTester tester, {
  required String initialLocation,
  AuthRepository? repository,
}) async {
  AppLogger.enabled = false;
  final authBloc = createAuthBloc(repository: repository);
  addTearDown(authBloc.close);
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const Text(homeMarker),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    BlocProvider.value(
      value: authBloc,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pump(pageTransition);
  return authBloc;
}

/// Menggulir ke [finder] lalu mengetik [text].
Future<void> enterField(WidgetTester tester, Finder finder, String text) async {
  await tester.ensureVisible(finder);
  await tester.enterText(finder, text);
}

/// Menunggu satu navigasi selesai tanpa `pumpAndSettle` (beberapa halaman
/// punya animasi berulang). Dua frame: router membangun halaman tujuan di
/// frame berikutnya, lalu transisinya selesai.
Future<void> pumpNavigation(WidgetTester tester) async {
  await tester.pump(pageTransition);
  await tester.pump(pageTransition);
}

/// Menggulir ke [finder], mengetuknya, lalu menunggu navigasi/animasi.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await pumpNavigation(tester);
}

/// Mengisi formulir login lalu menekan "Masuk Sekarang".
Future<void> submitLogin(
  WidgetTester tester, {
  String identifier = demoIdentifier,
  String password = demoPassword,
}) async {
  await enterField(
    tester,
    find.byKey(const Key('login_identifier')),
    identifier,
  );
  await enterField(tester, find.byKey(const Key('login_password')), password);
  await tapVisible(tester, find.byKey(const Key('login_submit')));
}
