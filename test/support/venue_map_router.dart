import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/core/router/venue_map_args.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/venue_map_page.dart';

import 'fakes.dart';

/// Memasang kartu dalam router minimal yang mengenal rute peta penuh.
Future<void> pumpCardWithVenueMapRouter(
  WidgetTester tester, {
  required Widget card,
}) async {
  final router = GoRouter(
    initialLocation: '/card',
    routes: [
      GoRoute(
        path: '/card',
        builder: (context, state) => Scaffold(body: card),
      ),
      GoRoute(
        path: AppRoutes.venueMap,
        builder: (context, state) => VenueMapPage(
          args: state.extra is VenueMapArgs
              ? state.extra as VenueMapArgs
              : null,
          routeService: FakeRouteService(),
          locationService: FakeLocationService(),
        ),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pump();
}
