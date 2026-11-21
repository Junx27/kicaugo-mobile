import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/remote_image.dart';

import '../../support/fake_image_http.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: SizedBox(width: 200, height: 120, child: child)),
    );
  }

  tearDown(() {
    PaintingBinding.instance.imageCache.clear();
  });

  testWidgets('menampilkan placeholder saat gambar masih dimuat', (
    tester,
  ) async {
    debugNetworkImageHttpClientProvider = () => FakeImageHttpClient(
      chunkDelay: const Duration(milliseconds: 100),
      chunkCount: 2,
    );

    try {
      await tester.pumpWidget(
        wrap(const RemoteImage(url: 'https://example.com/foto.png')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      expect(find.byIcon(Icons.image_outlined), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 200));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_outlined), findsNothing);
      expect(find.byType(Image), findsOneWidget);
    } finally {
      debugNetworkImageHttpClientProvider = null;
    }
  });

  testWidgets('menampilkan fallback saat gambar gagal', (tester) async {
    debugNetworkImageHttpClientProvider = () =>
        FakeImageHttpClient(statusCode: HttpStatus.notFound);

    try {
      await tester.pumpWidget(
        wrap(const RemoteImage(url: 'https://example.com/hilang.png')),
      );
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      debugNetworkImageHttpClientProvider = null;
    }
  });
}
