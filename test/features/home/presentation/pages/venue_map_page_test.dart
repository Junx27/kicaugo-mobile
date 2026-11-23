import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/router/venue_map_args.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/venue_map_page.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/venue_map_preview.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../../support/external_navigation_stub.dart';

/// Merekam URL yang dibuka tanpa memanggil aplikasi peta asli.
class RecordingMapPlatform extends UrlLauncherPlatform {
  final List<String> launched = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return true;
  }
}

const VenueMapArgs venueArgs = VenueMapArgs(
  latitude: -6.2,
  longitude: 106.8,
  title: 'Batavia Arena Gantangan',
  address: 'Jl. Daan Mogot KM 12, Jakarta Barat',
);

void main() {
  testWidgets('tanpa argumen menampilkan pesan lokasi belum tersedia', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VenueMapPage(args: null)));

    expect(find.text(HomeStrings.venueNotFound), findsOneWidget);
    expect(find.byType(VenueMapPreview), findsNothing);
  });

  testWidgets('peta penuh menampilkan peta, alamat, dan tombol navigasi', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: VenueMapPage(args: venueArgs)),
    );

    expect(find.text(HomeStrings.venueMapTitle), findsOneWidget);
    expect(find.text(venueArgs.title), findsOneWidget);
    expect(find.text(venueArgs.address), findsOneWidget);
    expect(find.byType(VenueMapPreview), findsOneWidget);
    expect(find.text(HomeStrings.openNavigation), findsOneWidget);
  });

  testWidgets('tombol navigasi membuka peta eksternal ke venue', (
    tester,
  ) async {
    final platform = RecordingMapPlatform();
    stubExternalNavigation(platform: platform);

    await tester.pumpWidget(
      const MaterialApp(home: VenueMapPage(args: venueArgs)),
    );
    await tester.ensureVisible(find.text(HomeStrings.openNavigation));
    await tester.tap(find.text(HomeStrings.openNavigation));
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump();
    }

    expect(platform.launched, hasLength(1));
    expect(platform.launched.single, contains('destination=-6.2%2C106.8'));
  });
}
