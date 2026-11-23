import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/venue_map_page.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/venue_map_preview.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/widgets/hero_ticket_card.dart';

import '../../../../support/external_navigation_stub.dart';
import '../../../../support/venue_map_router.dart';
import '../../support.dart';

void main() {
  testWidgets('preview peta tiket membuka halaman peta penuh', (tester) async {
    tester.view.physicalSize = const Size(420, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final ticket = demoTickets.upcoming.first;
    await pumpCardWithVenueMapRouter(
      tester,
      card: HeroTicketCard(ticket: ticket),
    );

    await tester.ensureVisible(find.byType(VenueMapPreview));
    await tester.tap(find.byType(VenueMapPreview));
    await tester.pumpAndSettle();

    expect(find.byType(VenueMapPage), findsOneWidget);
    // Label pin disembunyikan saat sheet detail terlihat.
    expect(find.text(ticket.event.venue), findsOneWidget);
  });

  testWidgets('tombol navigasi eksternal dapat dipakai', (tester) async {
    tester.view.physicalSize = const Size(420, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    stubExternalNavigation();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroTicketCard(ticket: demoTickets.upcoming.first),
        ),
      ),
    );
    await tester.ensureVisible(find.text(HomeStrings.openNavigation));
    await tester.tap(find.text(HomeStrings.openNavigation));
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump();
    }

    expect(tester.takeException(), isNull);
  });
}
