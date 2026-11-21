import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/top_bars.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/entities/help_center_content.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/usecases/get_help_center_content.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/help_center_strings.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/pages/help_center_page.dart';

import '../../help_center_fakes.dart';

const Size _viewport = Size(420, 4200);
const Duration _frame = Duration(milliseconds: 2);
const Duration _navigation = Duration(milliseconds: 600);
const String _startMarker = 'start-marker';
const String _profileMarker = 'profile-marker';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(_frame);
}

Future<void> _pumpNavigation(WidgetTester tester) async {
  await tester.pump(_navigation);
  await tester.pump(_navigation);
}

Future<void> _pumpHelpCenter(
  WidgetTester tester, {
  GetHelpCenterContent getHelpCenterContent = instantHelpCenter,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: HelpCenterPage(getHelpCenterContent: getHelpCenterContent),
    ),
  );
  await _settle(tester);
}

Future<void> _pumpRoutedHelpCenter(
  WidgetTester tester, {
  String initialLocation = AppRoutes.helpCenter,
  GetHelpCenterContent getHelpCenterContent = instantHelpCenter,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/start',
        builder: (context, state) => Scaffold(
          body: Center(
            child: TextButton(
              key: const Key('open_help'),
              onPressed: () => context.push(AppRoutes.helpCenter),
              child: const Text(_startMarker),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.helpCenter,
        builder: (context, state) =>
            HelpCenterPage(getHelpCenterContent: getHelpCenterContent),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const Scaffold(body: Text(_profileMarker)),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
  await _settle(tester);
}

void main() {
  testWidgets('menampilkan loading lalu seluruh konten bantuan', (
    tester,
  ) async {
    final completer = Completer<HelpCenterContent>();
    await _pumpHelpCenter(
      tester,
      getHelpCenterContent: GetHelpCenterContent(
        CompleterHelpCenterRepository(completer),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(sampleHelpCenter);
    await _settle(tester);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(HelpCenterStrings.title), findsOneWidget);
    expect(find.text(HelpCenterStrings.secure), findsOneWidget);
    expect(find.text(HelpCenterStrings.serviceEyebrow), findsOneWidget);
    expect(find.text(HelpCenterStrings.heading), findsOneWidget);
    expect(find.text(HelpCenterStrings.subtitle), findsOneWidget);
    expect(find.text(sampleHelpCenter.event.title), findsOneWidget);
    expect(find.text(sampleHelpCenter.event.venue), findsOneWidget);
    expect(find.text(sampleHelpCenter.event.registrationLabel), findsOneWidget);
    expect(find.text(HelpCenterStrings.fieldReady), findsOneWidget);
    expect(
      find.text(
        HelpCenterStrings.fieldHours(sampleHelpCenter.event.fieldHours),
      ),
      findsOneWidget,
    );
    expect(find.text(HelpCenterStrings.quickTitle), findsOneWidget);
    expect(find.text(HelpCenterStrings.quickCount(4)), findsOneWidget);
    expect(find.text(HelpCenterStrings.faqTitle), findsOneWidget);
    expect(find.text(HelpCenterStrings.faqTopicCount(4)), findsOneWidget);
    for (final contact in sampleHelpCenter.contacts) {
      expect(find.text(contact.name), findsOneWidget);
    }
    expect(find.text(HelpCenterStrings.supportTitle), findsOneWidget);
    expect(find.text(HelpCenterStrings.createTicket), findsOneWidget);
    expect(find.text(HelpCenterStrings.archived), findsOneWidget);
    expect(find.text(HelpCenterStrings.escalation), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpHelpCenter(
      tester,
      getHelpCenterContent: GetHelpCenterContent(
        FakeHelpCenterRepository(failuresRemaining: 1),
      ),
    );

    expect(find.text(helpCenterFailure), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await _settle(tester);

    expect(find.text(helpCenterFailure), findsNothing);
    expect(find.text(HelpCenterStrings.heading), findsOneWidget);
  });

  testWidgets('pencarian memfilter FAQ dan menampilkan hasil kosong', (
    tester,
  ) async {
    await _pumpHelpCenter(tester);
    final input = find.byKey(const Key('help_search_input'));

    await tester.enterText(input, 'offline');
    await tester.pump();

    expect(find.text(sampleHelpCenter.faqs.last.question), findsOneWidget);
    expect(find.text(sampleHelpCenter.faqs.first.question), findsNothing);
    expect(find.text(HelpCenterStrings.faqTopicCount(1)), findsOneWidget);

    await tester.enterText(input, 'tidak-ada');
    await tester.pump();

    expect(find.byKey(const Key('help_faq_empty')), findsOneWidget);
    expect(find.text(HelpCenterStrings.noResult), findsOneWidget);
    expect(find.text(HelpCenterStrings.faqTopicCount(0)), findsOneWidget);
  });

  testWidgets('FAQ bisa dibuka, berpindah, dan ditutup', (tester) async {
    await _pumpHelpCenter(tester);
    final offline = find.byKey(const Key('help_faq_offline'));
    final gantangan = find.byKey(const Key('help_faq_gantangan'));

    await tester.ensureVisible(offline);
    await tester.tap(offline);
    await tester.pump();

    expect(find.byKey(const Key('help_faq_answer_offline')), findsOneWidget);

    await tester.ensureVisible(gantangan);
    await tester.tap(gantangan);
    await tester.pump();

    expect(find.byKey(const Key('help_faq_answer_gantangan')), findsOneWidget);
    expect(find.byKey(const Key('help_faq_answer_offline')), findsNothing);

    await tester.tap(gantangan);
    await tester.pump();

    expect(find.byKey(const Key('help_faq_answer_gantangan')), findsNothing);
  });

  final actionIds = <String>['chat', 'refund', 'appeal', 'payment'];
  for (final id in actionIds) {
    testWidgets('aksi cepat $id menampilkan segera hadir', (tester) async {
      await _pumpHelpCenter(tester);
      final finder = find.byKey(Key('help_action_$id'));

      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  }

  testWidgets('tombol filter menampilkan segera hadir', (tester) async {
    await _pumpHelpCenter(tester);
    final finder = find.byKey(const Key('help_filter'));

    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pump();

    expect(find.text(AppConstants.comingSoon), findsOneWidget);
  });

  final contactIds = <String>['hendra', 'medical', 'secretariat'];
  for (final id in contactIds) {
    testWidgets('kontak $id menampilkan segera hadir', (tester) async {
      await _pumpHelpCenter(tester);
      final finder = find.byKey(Key('help_contact_$id'));

      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  }

  testWidgets('tombol buat tiket menampilkan segera hadir', (tester) async {
    await _pumpHelpCenter(tester);
    final finder = find.byKey(const Key('help_create_ticket'));

    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pump();

    expect(find.text(AppConstants.comingSoon), findsOneWidget);
  });

  testWidgets('tombol kembali menutup halaman bila ada riwayat', (
    tester,
  ) async {
    await _pumpRoutedHelpCenter(tester, initialLocation: '/start');

    await tester.tap(find.byKey(const Key('open_help')));
    await _pumpNavigation(tester);
    expect(find.byType(HelpCenterPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('help_back')));
    await _pumpNavigation(tester);

    expect(find.byType(HelpCenterPage), findsNothing);
    expect(find.text(_startMarker), findsOneWidget);
  });

  testWidgets('tombol kembali tanpa riwayat membuka Profil', (tester) async {
    await _pumpRoutedHelpCenter(tester);

    await tester.tap(find.byKey(const Key('help_back')));
    await _pumpNavigation(tester);

    expect(find.byType(HelpCenterPage), findsNothing);
    expect(find.text(_profileMarker), findsOneWidget);
  });

  testWidgets('avatar profil membuka Profil', (tester) async {
    await _pumpRoutedHelpCenter(tester);

    await tester.tap(find.byTooltip(profileTooltip));
    await _pumpNavigation(tester);

    expect(find.text(_profileMarker), findsOneWidget);
  });
}
