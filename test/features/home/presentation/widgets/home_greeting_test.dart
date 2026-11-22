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
}
