import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/router/app_router.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/auth_strings.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:rumahkicau_mobile/features/chat/presentation/pages/chat_page.dart';
import 'package:rumahkicau_mobile/features/community/presentation/pages/community_page.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/help_center_strings.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/pages/help_center_page.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/home_page.dart';
import 'package:rumahkicau_mobile/features/onboarding/presentation/onboarding_strings.dart';
import 'package:rumahkicau_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/pages/reminders_page.dart';
import 'package:rumahkicau_mobile/features/reminders/presentation/reminders_strings.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/pages/schedule_page.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/pages/ticket_history_page.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/pages/tickets_page.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/ticket_history_strings.dart';

import '../../support/pump_app.dart';

/// Melewati splash dan onboarding hingga halaman login tampil.
Future<void> _toLogin(WidgetTester tester) async {
  await tester.tap(find.text(OnboardingStrings.skip));
  await pumpNavigation(tester);
}

/// Finder stabil untuk tab navigasi bawah yang sekarang hanya berisi ikon.
Finder navTab(String label) => find.byKey(ValueKey('nav_item_$label'));

void main() {
  group('authRedirect', () {
    test('tanpa sesi, rute privat dialihkan ke login', () {
      expect(authRedirect(false, AppRoutes.home), AppRoutes.login);
      expect(authRedirect(false, AppRoutes.register), isNull);
    });

    test('dengan sesi, rute publik dialihkan ke beranda', () {
      expect(authRedirect(true, AppRoutes.login), AppRoutes.home);
      expect(authRedirect(true, AppRoutes.home), isNull);
    });
  });

  testWidgets('splash berlanjut ke onboarding lalu login', (tester) async {
    await pumpKicauKuApp(tester);
    expect(find.byType(OnboardingPage), findsOneWidget);

    await _toLogin(tester);

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('akun demo masuk lalu membuka Beranda', (tester) async {
    await pumpKicauKuApp(tester);
    await _toLogin(tester);

    await submitLogin(tester);
    await pumpNavigation(tester);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Halo, $demoName 👋'), findsOneWidget);
  });

  testWidgets('daftar dari login langsung masuk ke beranda', (tester) async {
    final authBloc = await pumpKicauKuApp(tester);
    await _toLogin(tester);

    await tapVisible(tester, find.text(AuthStrings.toRegister));
    expect(find.byType(RegisterPage), findsOneWidget);

    authBloc.add(
      const RegisterSubmitted(
        name: 'Sari',
        identifier: demoIdentifier,
        password: demoPassword,
      ),
    );
    await pumpNavigation(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('tanpa sesi, membuka beranda dialihkan ke login', (tester) async {
    await pumpKicauKuApp(tester);
    await _toLogin(tester);

    GoRouter.of(tester.element(find.byType(LoginPage))).go(AppRoutes.home);
    await pumpNavigation(tester);

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('tombol Keluar di Profil kembali ke login', (tester) async {
    await pumpKicauKuApp(tester);
    await _toLogin(tester);
    await submitLogin(tester);
    await pumpNavigation(tester);

    await tester.tap(navTab(HomeStrings.navProfile));
    await pumpNavigation(tester);
    await tapVisible(tester, find.byKey(const Key('profile_logout')));
    await pumpNavigation(tester);

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('menu bantuan di Profil membuka Pusat Bantuan', (tester) async {
    await pumpKicauKuApp(tester);
    await _toLogin(tester);
    await submitLogin(tester);
    await pumpNavigation(tester);

    await tester.tap(navTab(HomeStrings.navProfile));
    await pumpNavigation(tester);
    await tapVisible(tester, find.byKey(const Key('profile_help')));

    expect(find.byType(HelpCenterPage), findsOneWidget);
    expect(find.text(HelpCenterStrings.heading), findsOneWidget);
  });

  testWidgets('menu pengingat di Profil membuka halaman Pengingat', (
    tester,
  ) async {
    await pumpKicauKuApp(tester);
    await _toLogin(tester);
    await submitLogin(tester);
    await pumpNavigation(tester);

    await tester.tap(navTab(HomeStrings.navProfile));
    await pumpNavigation(tester);
    await tapVisible(tester, find.byKey(const Key('profile_reminders')));

    expect(find.byType(RemindersPage), findsOneWidget);
    expect(find.text(RemindersStrings.title), findsOneWidget);
  });

  testWidgets('menu riwayat tiket di Profil membuka halaman Riwayat Tiket', (
    tester,
  ) async {
    await pumpKicauKuApp(tester);
    await _toLogin(tester);
    await submitLogin(tester);
    await pumpNavigation(tester);

    await tester.tap(navTab(HomeStrings.navProfile));
    await pumpNavigation(tester);
    await tapVisible(tester, find.byKey(const Key('profile_history')));

    expect(find.byType(TicketHistoryPage), findsOneWidget);
    expect(find.text(TicketHistoryStrings.title), findsWidgets);
  });

  test('notifier meneruskan perubahan state AuthBloc', () async {
    final authBloc = createAuthBloc();
    addTearDown(authBloc.close);
    final notifier = AuthRouterNotifier(authBloc.stream);
    addTearDown(notifier.dispose);
    var notified = 0;
    notifier.addListener(() => notified++);

    authBloc.add(
      const LoginSubmitted(identifier: demoIdentifier, password: demoPassword),
    );
    await authBloc.stream.firstWhere((state) => state.isAuthenticated);
    await Future<void>.delayed(Duration.zero);

    expect(notified, greaterThan(0));
  });

  testWidgets(
    'tab Jadwal, Tiket Saya, Komunitas, dan Chat membuka halamannya',
    (tester) async {
      await pumpKicauKuApp(tester);
      await _toLogin(tester);
      await submitLogin(tester);
      await pumpNavigation(tester);
      expect(
        find.descendant(
          of: navTab(HomeStrings.navChat),
          matching: find.text('5'),
        ),
        findsOneWidget,
      );

      final tabs = <String, Type>{
        HomeStrings.navSchedule: SchedulePage,
        HomeStrings.navTickets: TicketsPage,
        HomeStrings.navCommunity: CommunityPage,
        HomeStrings.navChat: ChatPage,
      };
      for (final MapEntry(key: label, value: page) in tabs.entries) {
        await tester.tap(navTab(label));
        await pumpNavigation(tester);
        expect(find.byType(page), findsOneWidget);
      }

      await tester.tap(navTab(HomeStrings.navHome));
      await pumpNavigation(tester);
      expect(find.byType(HomePage), findsOneWidget);
    },
  );

  testWidgets('tab Komunitas membuka CommunityPage', (tester) async {
    await pumpKicauKuApp(tester);
    await _toLogin(tester);
    await submitLogin(tester);
    await pumpNavigation(tester);

    await tester.tap(navTab(HomeStrings.navCommunity));
    await pumpNavigation(tester);

    expect(find.byType(CommunityPage), findsOneWidget);
  });
}
