import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';
import 'package:rumahkicau_mobile/core/router/venue_map_args.dart';
import 'package:rumahkicau_mobile/core/routing/route_service.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/pages/venue_map_page.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/venue_map_preview.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../../support/external_navigation_stub.dart';
import '../../../../support/fakes.dart';

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
  schedule: 'Minggu, 6 Des • Gantangan Derkuku',
  distance: '2.4 km',
);

/// Rute palsu dari lokasi pengguna ke venue untuk test garis in-app.
const RoutePath sampleRoute = RoutePath(
  points: [LatLng(-6.1, 106.7), LatLng(-6.15, 106.75), LatLng(-6.2, 106.8)],
  distanceM: 2400,
  durationS: 600,
);

FakeLocationService userLocation() => FakeLocationService(
  location: const DeviceLocation(latitude: -6.1, longitude: 106.7),
);

Future<void> _pumpPage(
  WidgetTester tester, {
  VenueMapArgs? args = venueArgs,
  RouteService? routeService,
  LocationService? locationService,
}) {
  _setPhoneView(tester);
  return tester.pumpWidget(
    MaterialApp(
      home: VenueMapPage(
        args: args,
        routeService: routeService ?? FakeRouteService(),
        locationService: locationService ?? FakeLocationService(),
      ),
    ),
  );
}

/// Layar ponsel supaya kontrol peta tidak tertutup sheet detail.
void _setPhoneView(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Frame pertama menjalankan callback `onMapReady`, frame kedua rebuild state.
Future<void> _pumpMapReady(
  WidgetTester tester, {
  RouteService? routeService,
  LocationService? locationService,
}) async {
  await _pumpPage(
    tester,
    routeService: routeService,
    locationService: locationService,
  );
  await tester.pump();
  await tester.pump();
}

MapController _controllerOf(WidgetTester tester) =>
    tester.widget<FlutterMap>(find.byType(FlutterMap)).mapController!;

void _stubClipboard() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (call) async => null);
}

void main() {
  testWidgets('tanpa argumen menampilkan pesan lokasi belum tersedia', (
    tester,
  ) async {
    await _pumpPage(tester, args: null);

    expect(find.text(HomeStrings.venueNotFound), findsOneWidget);
    expect(find.byType(VenueMapPreview), findsNothing);
  });

  testWidgets('overlay menampilkan judul, jadwal, jarak, dan kontrol', (
    tester,
  ) async {
    await _pumpPage(tester);

    expect(find.text(HomeStrings.venueMapTitle), findsOneWidget);
    // Saat detail terlihat, label pin disembunyikan agar tidak tumpang tindih.
    expect(find.text(venueArgs.title), findsOneWidget);
    expect(find.byKey(const Key('venue_pin_label')), findsNothing);
    expect(find.textContaining(venueArgs.schedule), findsOneWidget);
    expect(find.textContaining(venueArgs.address), findsOneWidget);
    expect(find.text(venueArgs.distance), findsOneWidget);
    expect(find.byType(VenueMapPreview), findsOneWidget);
    expect(find.text(HomeStrings.openNavigation), findsOneWidget);
    expect(find.text(HomeStrings.copyAddress), findsOneWidget);
    expect(find.text(HomeStrings.paddockParking), findsOneWidget);
    expect(find.byTooltip(HomeStrings.zoomInTooltip), findsOneWidget);
    expect(find.byTooltip(HomeStrings.zoomOutTooltip), findsOneWidget);
    expect(find.byTooltip(HomeStrings.locateTooltip), findsOneWidget);
    expect(find.byTooltip(HomeStrings.routeTooltip), findsOneWidget);
    expect(find.byTooltip(HomeStrings.compassTooltip), findsOneWidget);
    expect(find.byTooltip(HomeStrings.backTooltip), findsOneWidget);
  });

  testWidgets('alamat sama dengan jadwal tidak ditampilkan dua kali', (
    tester,
  ) async {
    const duplicate = VenueMapArgs(
      latitude: -6.2,
      longitude: 106.8,
      title: 'Gantangan Derkuku',
      address: 'Minggu, 6 Des • Gantangan Derkuku',
      schedule: 'Minggu, 6 Des • Gantangan Derkuku',
    );
    await _pumpPage(tester, args: duplicate);

    expect(find.text(duplicate.schedule), findsOneWidget);
  });

  testWidgets('tombol navigasi membuka peta eksternal ke venue', (
    tester,
  ) async {
    final platform = RecordingMapPlatform();
    stubExternalNavigation(platform: platform);
    await _pumpPage(tester);

    await tester.ensureVisible(find.text(HomeStrings.openNavigation));
    await tester.tap(find.text(HomeStrings.openNavigation));
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump();
    }

    expect(platform.launched, hasLength(1));
    expect(platform.launched.single, contains('destination=-6.2%2C106.8'));
  });

  testWidgets('tombol rute menggambar garis dari lokasi terkini ke venue', (
    tester,
  ) async {
    final platform = RecordingMapPlatform();
    stubExternalNavigation(platform: platform);
    final routes = FakeRouteService(route: sampleRoute);
    await _pumpMapReady(
      tester,
      routeService: routes,
      locationService: userLocation(),
    );
    final controller = _controllerOf(tester);

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(routes.fetchCalls, 1);
    expect(platform.launched, isEmpty);
    final polyline = tester.widget<PolylineLayer>(find.byType(PolylineLayer));
    expect(polyline.polylines.single.points, sampleRoute.points);
    expect(find.byKey(const Key('venue_route_origin')), findsOneWidget);
    expect(find.text('${HomeStrings.routeShown} • 2.4 km'), findsOneWidget);
    // Sheet menutup supaya garis rute terlihat penuh.
    final sheet = tester.getRect(find.byKey(const Key('venue_detail_sheet')));
    expect(sheet.top, greaterThan(900));
    // Kamera menyesuaikan agar origin dan venue masuk frame.
    expect(controller.camera.center.latitude, closeTo(-6.15, 0.01));
    expect(controller.camera.center.longitude, closeTo(106.75, 0.01));
  });

  testWidgets('rute tanpa jarak memakai pesan polos', (tester) async {
    final noDistance = RoutePath(points: sampleRoute.points);
    await _pumpMapReady(
      tester,
      routeService: FakeRouteService(route: noDistance),
      locationService: userLocation(),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.routeShown), findsOneWidget);
  });

  testWidgets('lokasi tidak tersedia menampilkan pesan tanpa menghitung rute', (
    tester,
  ) async {
    final routes = FakeRouteService(route: sampleRoute);
    await _pumpPage(
      tester,
      routeService: routes,
      locationService: FakeLocationService(),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.routeOriginUnavailable), findsOneWidget);
    expect(routes.fetchCalls, 0);
    expect(find.byType(PolylineLayer), findsNothing);
  });

  testWidgets('izin lokasi gagal menampilkan pesan origin', (tester) async {
    await _pumpPage(
      tester,
      locationService: FakeLocationService(error: Exception('denied')),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.routeOriginUnavailable), findsOneWidget);
    expect(find.byType(PolylineLayer), findsNothing);
  });

  testWidgets('rute gagal dihitung menampilkan pesan coba lagi', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      routeService: FakeRouteService(),
      locationService: userLocation(),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.routeUnavailable), findsOneWidget);
    expect(find.byType(PolylineLayer), findsNothing);
  });

  testWidgets('provider rute error menampilkan pesan coba lagi', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      routeService: FakeRouteService(error: Exception('offline')),
      locationService: userLocation(),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.routeUnavailable), findsOneWidget);
  });

  testWidgets('kegagalan berikutnya tidak menghapus garis lama', (
    tester,
  ) async {
    final routes = FakeRouteService(route: sampleRoute);
    await _pumpMapReady(
      tester,
      routeService: routes,
      locationService: userLocation(),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    expect(find.byType(PolylineLayer), findsOneWidget);

    routes.route = null;
    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.routeUnavailable), findsOneWidget);
    expect(find.byType(PolylineLayer), findsOneWidget);
  });

  testWidgets('loading tampil dan tombol rute tidak bisa dipicu dua kali', (
    tester,
  ) async {
    final completer = Completer<RoutePath?>();
    final routes = FakeRouteService(completer: completer);
    await _pumpMapReady(
      tester,
      routeService: routes,
      locationService: userLocation(),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    expect(routes.fetchCalls, 1);

    completer.complete(sampleRoute);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(PolylineLayer), findsOneWidget);
  });

  testWidgets('hasil rute diabaikan bila halaman sudah ditutup', (
    tester,
  ) async {
    final completer = Completer<RoutePath?>();
    await _pumpMapReady(
      tester,
      routeService: FakeRouteService(completer: completer),
      locationService: userLocation(),
    );

    await tester.tap(find.byTooltip(HomeStrings.routeTooltip));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    completer.complete(sampleRoute);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('tombol zoom mengubah zoom kamera', (tester) async {
    await _pumpMapReady(tester);
    final controller = _controllerOf(tester);
    final initial = controller.camera.zoom;

    await tester.tap(find.byTooltip(HomeStrings.zoomInTooltip));
    await tester.pump();
    expect(controller.camera.zoom, initial + 1);

    await tester.tap(find.byTooltip(HomeStrings.zoomOutTooltip));
    await tester.pump();
    expect(controller.camera.zoom, initial);
  });

  testWidgets('tombol lokasi dan orientasi mengembalikan kamera ke venue', (
    tester,
  ) async {
    await _pumpMapReady(tester);
    final controller = _controllerOf(tester);
    const panned = LatLng(-7.1, 110.3);
    controller.move(panned, 17);
    await tester.pump();

    await tester.tap(find.byTooltip(HomeStrings.locateTooltip));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(
      controller.camera.center,
      LatLng(venueArgs.latitude, venueArgs.longitude),
    );
    expect(controller.camera.zoom, VenueMapPreview.defaultZoom);
    expect(find.text(HomeStrings.venueLocated), findsOneWidget);

    controller.move(panned, 17);
    await tester.pump();
    await tester.tap(find.byTooltip(HomeStrings.compassTooltip));
    await tester.pump();

    expect(
      controller.camera.center,
      LatLng(venueArgs.latitude, venueArgs.longitude),
    );
    expect(controller.camera.zoom, VenueMapPreview.defaultZoom);
  });

  testWidgets('salin alamat memberi umpan balik', (tester) async {
    _stubClipboard();
    await _pumpPage(tester);

    await tester.tap(find.text(HomeStrings.copyAddress));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.addressCopied), findsOneWidget);
  });

  testWidgets('parkir paddock menampilkan informasi parkir', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text(HomeStrings.paddockParking));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(HomeStrings.parkingInfo), findsOneWidget);
  });

  testWidgets('sheet detail menutup sampai tepi bawah layar', (tester) async {
    tester.view.padding = const FakeViewPadding(bottom: 32);
    await _pumpPage(tester);

    final sheet = tester.getRect(find.byKey(const Key('venue_detail_sheet')));
    expect(sheet.bottom, 900);
  });

  testWidgets('geser ke bawah menutup sheet dan memunculkan label pin', (
    tester,
  ) async {
    await _pumpPage(tester);
    expect(find.byKey(const Key('venue_pin_label')), findsNothing);

    await tester.fling(
      find.byKey(const Key('venue_detail_sheet')),
      const Offset(0, 120),
      1200,
    );
    await tester.pumpAndSettle();

    // Kartu masih di tree tapi sudah bergeser keluar layar.
    final sheet = tester.getRect(find.byKey(const Key('venue_detail_sheet')));
    expect(sheet.top, greaterThan(900));
    expect(find.byKey(const Key('venue_pin_label')), findsOneWidget);
  });

  testWidgets('ketuk pin memunculkan kembali sheet detail', (tester) async {
    await _pumpPage(tester);
    await tester.fling(
      find.byKey(const Key('venue_detail_sheet')),
      const Offset(0, 120),
      1200,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('venue_pin')));
    await tester.pumpAndSettle();

    final sheet = tester.getRect(find.byKey(const Key('venue_detail_sheet')));
    expect(sheet.bottom, 900);
    expect(find.text(HomeStrings.openNavigation), findsOneWidget);
    expect(find.byKey(const Key('venue_pin_label')), findsNothing);
  });

  testWidgets('handle sheet bisa diketuk untuk menutup detail', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.byKey(const Key('venue_sheet_handle')));
    await tester.pumpAndSettle();

    final sheet = tester.getRect(find.byKey(const Key('venue_detail_sheet')));
    expect(sheet.top, greaterThan(900));
    expect(find.byKey(const Key('venue_pin_label')), findsOneWidget);
  });

  testWidgets('tombol kembali aman tanpa rute sebelumnya', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.byTooltip(HomeStrings.backTooltip));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
