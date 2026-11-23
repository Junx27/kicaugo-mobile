import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/featured_contest.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/venue_map_page.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/featured_contest_card.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/venue_map_preview.dart';

import '../../../../support/external_navigation_stub.dart';
import '../../../../support/venue_map_router.dart';

const contest = FeaturedContest(
  title: 'Lomba Test',
  schedule: 'Sabtu • Arena Test',
  distance: '1 KM',
  prize: 'Rp 1 Jt',
  slots: '4 Gantangan',
  attendees: (initials: <String>['AB'], others: 2),
  latitude: -6.2,
  longitude: 106.8,
);

const contestWithoutMap = FeaturedContest(
  title: 'Lomba Tanpa Peta',
  schedule: 'Minggu • Arena Test',
  distance: '2 KM',
  prize: 'Rp 500 Rb',
  slots: '2 Gantangan',
  attendees: (initials: <String>['CD'], others: 1),
);

void main() {
  testWidgets('menampilkan tombol buka navigasi', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contest)),
      ),
    );
    await tester.pump();

    expect(find.text(HomeStrings.openNavigation), findsOneWidget);
    expect(find.byType(FeaturedContestCard), findsOneWidget);
  });

  testWidgets('preview peta membuka halaman peta penuh', (tester) async {
    await pumpCardWithVenueMapRouter(
      tester,
      card: const FeaturedContestCard(contest: contest),
    );

    await tester.ensureVisible(find.byType(VenueMapPreview));
    await tester.tap(find.byType(VenueMapPreview));
    await tester.pumpAndSettle();

    expect(find.byType(VenueMapPage), findsOneWidget);
    expect(find.text(contest.title), findsOneWidget);
  });

  testWidgets('tombol navigasi eksternal dapat dipakai', (tester) async {
    stubExternalNavigation();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contest)),
      ),
    );
    await tester.ensureVisible(find.text(HomeStrings.openNavigation));
    await tester.tap(find.text(HomeStrings.openNavigation));
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump();
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('peta full-bleed berada di atas badge', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contest)),
      ),
    );
    await tester.pump();

    final card = tester.getRect(find.byType(FeaturedContestCard));
    final map = tester.getRect(find.byType(VenueMapPreview));
    final nearest = tester.getRect(
      find.text('${HomeStrings.nearestPrefix} ${contest.distance}'),
    );
    final category = tester.getRect(find.text(HomeStrings.mainCategory));
    final title = tester.getRect(find.text(contest.title));

    expect(map.top, closeTo(card.top, 1));
    expect(map.width, closeTo(card.width, 1));
    expect(map.bottom, lessThanOrEqualTo(nearest.top));
    expect(nearest.top, lessThan(title.top));
    expect(nearest.left, lessThan(category.left));
  });

  testWidgets('tanpa koordinat tidak menampilkan peta', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contestWithoutMap)),
      ),
    );
    await tester.pump();

    expect(find.byType(VenueMapPreview), findsNothing);
    expect(find.text(contestWithoutMap.title), findsOneWidget);
  });
}
