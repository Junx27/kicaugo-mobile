import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/widgets/icon_pill.dart';
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
    // Label pin disembunyikan saat sheet detail terlihat.
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
    final detail = tester.getRect(find.byKey(const Key('see_detail_link')));
    final title = tester.getRect(find.text(contest.title));

    expect(map.top, closeTo(card.top, 1));
    expect(map.width, closeTo(card.width, 1));
    expect(map.bottom, lessThanOrEqualTo(nearest.top));
    expect(nearest.top, lessThan(title.top));
    expect(nearest.left, lessThan(detail.left));
    expect(find.text(HomeStrings.mainCategory), findsNothing);
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

  testWidgets('Lihat Detail menggantikan Kategori Utama dan memuat panah', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contest)),
      ),
    );
    await tester.pump();

    final link = find.byKey(const Key('see_detail_link'));
    expect(link, findsOneWidget);
    expect(
      find.descendant(of: link, matching: find.byType(IconPill)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: link, matching: find.byType(FilledButton)),
      findsNothing,
    );
    final arrow = find.descendant(
      of: link,
      matching: find.byIcon(Icons.arrow_forward_rounded),
    );
    expect(arrow, findsOneWidget);
    expect(tester.widget<Icon>(arrow).color, AppColors.textPrimary);
    expect(
      tester.getRect(arrow).left,
      greaterThan(tester.getRect(find.text(HomeStrings.seeDetail)).right),
    );
    expect(find.text(HomeStrings.mainCategory), findsNothing);

    final text = tester.widget<Text>(
      find.descendant(of: link, matching: find.text(HomeStrings.seeDetail)),
    );
    expect(text.style?.color, AppColors.textPrimary);
  });

  testWidgets('taut Lihat Detail menampilkan pesan segera hadir', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contest)),
      ),
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('see_detail_link')));
    await tester.tap(find.byKey(const Key('see_detail_link')));
    await tester.pump();

    expect(find.text(AppConstants.comingSoon), findsOneWidget);
  });

  testWidgets('attendees sebaris dengan judul dan navigasi di paling bawah', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contest)),
      ),
    );
    await tester.pump();

    final card = tester.getRect(find.byType(FeaturedContestCard));
    final map = tester.getRect(find.byType(VenueMapPreview));
    final attendees = tester.getRect(find.text('+${contest.attendees.others}'));
    final detail = tester.getRect(find.byKey(const Key('see_detail_link')));
    final nearest = tester.getRect(
      find.text('${HomeStrings.nearestPrefix} ${contest.distance}'),
    );
    final title = tester.getRect(find.text(contest.title));
    final titleText = tester.widget<Text>(find.text(contest.title));
    expect(titleText.maxLines, isNull);
    expect(titleText.overflow, isNull);

    final address = tester.getRect(find.text(contest.schedule));
    final prize = tester.getRect(find.text(HomeStrings.totalPrize));
    final navigation = tester.getRect(
      find.byWidgetPredicate((widget) => widget is FilledButton),
    );

    expect(find.text(HomeStrings.confirmed), findsNothing);
    expect(map.bottom, lessThanOrEqualTo(nearest.top));
    expect(detail.left, greaterThan(nearest.right));
    expect(title.top, greaterThan(nearest.top));
    expect(attendees.left, greaterThan(title.right));
    expect(
      (attendees.top + attendees.bottom) / 2,
      closeTo((title.top + title.bottom) / 2, 12),
    );
    expect(address.top, greaterThan(title.bottom));
    expect(prize.top, greaterThan(address.bottom));
    expect(navigation.top, greaterThan(prize.bottom));
    expect(navigation.bottom, closeTo(card.bottom - 20, 2));
  });
}
