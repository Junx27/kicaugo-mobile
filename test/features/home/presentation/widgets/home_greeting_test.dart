import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/home_greeting.dart';

import '../../../../support/fake_image_http.dart';

void main() {
  testWidgets('avatar dari URL dirender sebagai NetworkImage', (tester) async {
    debugNetworkImageHttpClientProvider = FakeImageHttpClient.new;

    try {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeGreeting(
              greeting: 'Selamat pagi',
              name: 'Junx',
              liveCount: 3,
              avatarUrl: 'https://example.com/avatar.png',
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isA<NetworkImage>());
      expect(
        (avatar.backgroundImage! as NetworkImage).url,
        'https://example.com/avatar.png',
      );
    } finally {
      debugNetworkImageHttpClientProvider = null;
    }
  });

  testWidgets('menampilkan ikon verified biru bila organizer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeGreeting(
            greeting: 'Selamat pagi',
            name: 'Junx',
            liveCount: 3,
            isOrganizer: true,
          ),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.verified_rounded));
    expect(icon.color, Colors.blue);
  });

  testWidgets('tidak menampilkan ikon verified bila bukan organizer', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeGreeting(
            greeting: 'Selamat pagi',
            name: 'Junx',
            liveCount: 3,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.verified_rounded), findsNothing);
  });
}
