import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/splash/presentation/pages/splash_page.dart';

const _nextMarker = 'onboarding-test';

/// Memasang splash di router minimal dengan rute onboarding penanda.
Future<void> _pumpSplash(WidgetTester tester) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const Text(_nextMarker),
      ),
    ],
  );
  addTearDown(router.dispose);
  return tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
}

void main() {
  testWidgets('menampilkan seluruh elemen splash', (tester) async {
    await _pumpSplash(tester);

    expect(find.text(AppConstants.splashEyebrow), findsOneWidget);
    expect(find.text(AppConstants.appName, findRichText: true), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);
    expect(find.text(AppConstants.splashLoading), findsOneWidget);
    expect(find.text(AppConstants.appVersionLabel), findsOneWidget);
    expect(find.text(AppConstants.splashProBadge), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('animasi berjalan tanpa error sebelum waktu habis', (
    tester,
  ) async {
    await _pumpSplash(tester);

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text(_nextMarker), findsNothing);
  });

  testWidgets('pindah ke onboarding setelah durasi splash', (tester) async {
    await _pumpSplash(tester);

    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    expect(find.text(_nextMarker), findsOneWidget);
    expect(find.byType(SplashPage), findsNothing);
  });

  testWidgets('timer dibatalkan bila splash ditutup lebih awal', (
    tester,
  ) async {
    await _pumpSplash(tester);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(AppConstants.splashDuration);

    expect(tester.takeException(), isNull);
  });
}
