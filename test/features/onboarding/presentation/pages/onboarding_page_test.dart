import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/onboarding/presentation/models/onboarding_slide.dart';
import 'package:rumahkicau_mobile/features/onboarding/presentation/onboarding_strings.dart';
import 'package:rumahkicau_mobile/features/onboarding/presentation/pages/onboarding_page.dart';

const _loginMarker = 'login-test';
const _settle = Duration(milliseconds: 600);
final _cta = find.byKey(const Key('onboarding_cta'));

/// Memasang onboarding di router minimal dengan rute login penanda.
Future<void> _pumpOnboarding(WidgetTester tester) {
  final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Text(_loginMarker),
      ),
    ],
  );
  addTearDown(router.dispose);
  return tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
}

/// Menggulir ke [finder] lalu mengetuknya, kemudian menunggu animasi slide.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump(_settle);
}

void _expectSlide(int index) {
  final slide = onboardingSlides[index];
  expect(find.text(slide.title), findsOneWidget);
  expect(find.text(slide.ctaLabel), findsOneWidget);
}

void main() {
  testWidgets('slide pertama menampilkan seluruh bagian halaman', (
    tester,
  ) async {
    await _pumpOnboarding(tester);

    _expectSlide(0);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(OnboardingStrings.skip), findsOneWidget);
    expect(find.text(onboardingSlides[0].badge.label), findsOneWidget);
    expect(find.text(OnboardingStrings.stickerContests), findsWidgets);
    expect(find.text(OnboardingStrings.birdClasses.first), findsWidgets);
    expect(find.text('1. Cari Lomba'), findsOneWidget);
    expect(find.text(OnboardingStrings.statCommunityValue), findsOneWidget);
    expect(find.text(OnboardingStrings.trustNote), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab memilih slide secara langsung', (tester) async {
    await _pumpOnboarding(tester);

    await _tap(tester, find.text('3. Beli Tiket'));

    _expectSlide(2);
  });

  testWidgets('geser kartu ke kiri membuka slide berikutnya', (tester) async {
    await _pumpOnboarding(tester);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    // Frame pertama memulai simulasi balistik, frame kedua menyelesaikannya.
    await tester.pump(_settle);
    await tester.pump(_settle);

    _expectSlide(1);
  });

  testWidgets('CTA maju per slide lalu selesai ke login', (tester) async {
    await _pumpOnboarding(tester);

    await _tap(tester, _cta);
    _expectSlide(1);
    await _tap(tester, _cta);
    _expectSlide(2);

    await _tap(tester, _cta);
    await tester.pumpAndSettle();

    expect(find.text(_loginMarker), findsOneWidget);
  });

  testWidgets('Lewati langsung menuju login', (tester) async {
    await _pumpOnboarding(tester);

    await tester.tap(find.text(OnboardingStrings.skip));
    await tester.pumpAndSettle();

    expect(find.text(_loginMarker), findsOneWidget);
  });
}
