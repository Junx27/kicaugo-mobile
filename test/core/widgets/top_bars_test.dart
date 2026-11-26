import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/top_bars.dart';

const _profileMarker = 'profil-test';

Future<void> _pump(WidgetTester tester, Widget bar) async {
  final router = GoRouter(
    initialLocation: '/bar',
    routes: [
      GoRoute(
        path: '/bar',
        builder: (context, state) => Scaffold(body: bar),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const Text(_profileMarker),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
}

void main() {
  testWidgets('BrandTopBar menampilkan nama, badge, subtitle, dan aksi', (
    tester,
  ) async {
    var tapped = 0;
    await _pump(
      tester,
      BrandTopBar(
        subtitle: const Text('Jabodetabek'),
        badge: const Text('LIVE'),
        actions: [
          TopBarIconButton(
            icon: Icons.event,
            tooltip: 'Kalender',
            onPressed: () => tapped++,
          ),
        ],
      ),
    );

    expect(find.text('KicauGo', findRichText: true), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('Jabodetabek'), findsOneWidget);
    await tester.tap(find.byTooltip('Kalender'));
    expect(tapped, 1);
  });

  testWidgets('TitleTopBar menampilkan judul dan avatar membuka Profil', (
    tester,
  ) async {
    const createBar = TitleTopBar.new;
    await _pump(tester, createBar(title: 'Tiket Saya'));

    expect(find.text('Tiket Saya'), findsOneWidget);
    await tester.tap(find.byTooltip(profileTooltip));
    await tester.pumpAndSettle();

    expect(find.text(_profileMarker), findsOneWidget);
  });

  testWidgets('titik penanda hanya tampil bila showDot', (tester) async {
    await _pump(
      tester,
      Row(
        children: [
          TopBarIconButton(icon: Icons.add, tooltip: 'A', onPressed: () {}),
          TopBarIconButton(
            icon: Icons.notifications,
            tooltip: 'B',
            showDot: true,
            onPressed: () {},
          ),
        ],
      ),
    );

    final badges = tester.widgetList<Badge>(find.byType(Badge)).toList();
    expect(badges.map((badge) => badge.isLabelVisible), [false, true]);
  });
}
