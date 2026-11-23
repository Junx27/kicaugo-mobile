import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';
import 'package:rumahkicau_mobile/core/utils/external_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Lokasi pengguna palsu untuk menguji origin URL.
class FakeLocationService implements LocationService {
  const FakeLocationService(this.location);

  final DeviceLocation? location;

  @override
  Future<DeviceLocation?> readCurrentLocation() async => location;
}

/// Layanan lokasi yang melempar error, misalnya timeout pembacaan.
class ThrowingLocationService implements LocationService {
  const ThrowingLocationService();

  @override
  Future<DeviceLocation?> readCurrentLocation() =>
      Future.error(Exception('location timeout'));
}

/// Tombol dalam [Scaffold] agar [showComingSoon] punya konteks valid.
Future<void> tapNavigate(
  WidgetTester tester, {
  required Future<void> Function(BuildContext context) action,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: IconButton(
              key: const Key('open_navigation'),
              onPressed: () => unawaited(action(context)),
              icon: const Icon(Icons.map),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(const Key('open_navigation')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lokasi tersedia mengirim origin dan destination', (
    tester,
  ) async {
    final launched = <Uri>[];
    await tapNavigate(
      tester,
      action: (context) => openExternalNavigation(
        context: context,
        destinationLatitude: -6.2,
        destinationLongitude: 106.8,
        destinationQuery: 'Arena',
        locationService: const FakeLocationService(
          DeviceLocation(latitude: -6.1, longitude: 106.7),
        ),
        canLaunch: (uri) async => true,
        launch: (uri, mode) async {
          expect(mode, LaunchMode.externalApplication);
          launched.add(uri);
          return true;
        },
      ),
    );

    expect(launched, hasLength(1));
    expect(launched.single.toString(), contains('origin=-6.1%2C106.7'));
    expect(launched.single.toString(), contains('destination=-6.2%2C106.8'));
    expect(find.text(AppConstants.comingSoon), findsNothing);
    expect(find.text(AppConstants.navigationOriginUnavailable), findsNothing);
  });

  testWidgets('izin ditolak tetap membuka navigasi tanpa origin', (
    tester,
  ) async {
    final launched = <Uri>[];
    await tapNavigate(
      tester,
      action: (context) => openExternalNavigation(
        context: context,
        destinationLatitude: -6.2,
        destinationLongitude: 106.8,
        destinationQuery: 'Arena',
        locationService: const FakeLocationService(null),
        canLaunch: (uri) async => true,
        launch: (uri, mode) async {
          launched.add(uri);
          return true;
        },
      ),
    );

    expect(launched, hasLength(1));
    expect(launched.single.toString(), isNot(contains('origin=')));
    expect(find.text(AppConstants.navigationOriginUnavailable), findsOneWidget);
  });

  testWidgets('layanan lokasi gagal tetap membuka navigasi tanpa origin', (
    tester,
  ) async {
    final launched = <Uri>[];
    await tapNavigate(
      tester,
      action: (context) => openExternalNavigation(
        context: context,
        destinationLatitude: -6.2,
        destinationLongitude: 106.8,
        destinationQuery: 'Arena',
        locationService: const ThrowingLocationService(),
        canLaunch: (uri) async => true,
        launch: (uri, mode) async {
          launched.add(uri);
          return true;
        },
      ),
    );

    expect(launched, hasLength(1));
    expect(launched.single.toString(), isNot(contains('origin=')));
    expect(find.text(AppConstants.navigationOriginUnavailable), findsOneWidget);
  });

  testWidgets('tanpa koordinat dan query menampilkan segera hadir', (
    tester,
  ) async {
    await tapNavigate(
      tester,
      action: (context) => openExternalNavigation(
        context: context,
        destinationQuery: '  ',
        locationService: const FakeLocationService(
          DeviceLocation(latitude: -6.1, longitude: 106.7),
        ),
      ),
    );

    expect(find.text(AppConstants.comingSoon), findsOneWidget);
  });

  testWidgets('url tidak dapat dibuka menampilkan segera hadir', (
    tester,
  ) async {
    var launched = false;
    await tapNavigate(
      tester,
      action: (context) => openExternalNavigation(
        context: context,
        destinationLatitude: -6.2,
        destinationLongitude: 106.8,
        destinationQuery: 'Arena',
        locationService: const FakeLocationService(
          DeviceLocation(latitude: -6.1, longitude: 106.7),
        ),
        canLaunch: (uri) async => false,
        launch: (uri, mode) async {
          launched = true;
          return true;
        },
      ),
    );

    expect(launched, isFalse);
    expect(find.text(AppConstants.comingSoon), findsOneWidget);
  });
}
