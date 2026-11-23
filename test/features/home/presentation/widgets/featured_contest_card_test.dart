import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/featured_contest.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/featured_contest_card.dart';

void main() {
  testWidgets('menampilkan tombol buka navigasi', (tester) async {
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

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FeaturedContestCard(contest: contest)),
      ),
    );
    await tester.pump();

    expect(find.text('Buka navigasi'), findsOneWidget);
    expect(find.byType(FeaturedContestCard), findsOneWidget);
  });
}
