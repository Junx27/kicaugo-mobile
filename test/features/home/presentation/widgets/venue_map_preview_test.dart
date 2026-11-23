import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/routing/route_service.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/utils/basemap_url.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/venue_map_preview.dart';

const _firstVenue = LatLng(-6.2, 106.8);
const _secondVenue = LatLng(-7.1, 110.3);

Future<void> _pumpPreview(WidgetTester tester, LatLng center) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: VenueMapPreview(
          latitude: center.latitude,
          longitude: center.longitude,
        ),
      ),
    ),
  );
}

MapController _controllerOf(WidgetTester tester) =>
    tester.widget<FlutterMap>(find.byType(FlutterMap)).mapController!;

void main() {
  testWidgets(
    'perubahan koordinat memindahkan kamera dan mempertahankan zoom',
    (tester) async {
      await _pumpPreview(tester, _firstVenue);
      await tester.pump();

      final controller = _controllerOf(tester);
      controller.move(_firstVenue, 17);
      await tester.pump();
      expect(controller.camera.center, _firstVenue);
      expect(controller.camera.zoom, 17);

      await _pumpPreview(tester, _secondVenue);
      await tester.pump();

      expect(controller.camera.center, _secondVenue);
      expect(controller.camera.zoom, 17);
    },
  );

  testWidgets('koordinat sama tidak mengembalikan kamera ke titik awal', (
    tester,
  ) async {
    await _pumpPreview(tester, _firstVenue);
    await tester.pump();

    final controller = _controllerOf(tester);
    const panned = LatLng(-6.5, 107.2);
    controller.move(panned, 16);
    await tester.pump();

    await _pumpPreview(tester, _firstVenue);
    await tester.pump();

    expect(controller.camera.center, panned);
    expect(controller.camera.zoom, 16);
  });

  testWidgets('controller eksternal, label pin, dan callback siap dipakai', (
    tester,
  ) async {
    final controller = MapController();
    var readyCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueMapPreview(
            latitude: _firstVenue.latitude,
            longitude: _firstVenue.longitude,
            options: VenueMapOptions(
              controller: controller,
              markerLabel: 'Gantangan Derkuku',
              onReady: () => readyCalls++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(_controllerOf(tester), same(controller));
    expect(find.text('Gantangan Derkuku'), findsOneWidget);
    expect(find.byKey(const Key('venue_pin_dot')), findsOneWidget);
    expect(readyCalls, 1);

    controller.dispose();
  });

  testWidgets('label bisa disembunyikan dan pin tetap bisa diketuk', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueMapPreview(
            latitude: _firstVenue.latitude,
            longitude: _firstVenue.longitude,
            options: VenueMapOptions(
              markerLabel: 'Gantangan Derkuku',
              showMarkerLabel: false,
              onMarkerTap: () => taps++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Gantangan Derkuku'), findsNothing);
    expect(find.byKey(const Key('venue_pin_dot')), findsNothing);
    expect(find.byKey(const Key('venue_pin')), findsOneWidget);

    await tester.tap(find.byKey(const Key('venue_pin')));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('rute menggambar polyline dan titik asal pengguna', (
    tester,
  ) async {
    // Preview hanya tinggi 160px; titik asal harus sangat dekat venue agar
    // masuk viewport pada zoom bawaan.
    const route = RoutePath(
      points: [
        LatLng(-6.198, 106.798),
        LatLng(-6.199, 106.799),
        LatLng(-6.2, 106.8),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueMapPreview(
            latitude: _firstVenue.latitude,
            longitude: _firstVenue.longitude,
            route: route,
          ),
        ),
      ),
    );
    await tester.pump();

    final polyline = tester.widget<PolylineLayer>(find.byType(PolylineLayer));
    final line = polyline.polylines.single;
    expect(line.points, route.points);
    expect(line.color, AppColors.blueStrong);
    expect(line.borderColor, AppColors.surface);
    expect(line.borderStrokeWidth, greaterThan(0));

    final origin = tester.widget<Container>(
      find.byKey(const Key('venue_route_origin')),
    );
    final decoration = origin.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.blueStrong);
    expect(decoration.border, isNotNull);
  });

  testWidgets('tile memakai CARTO Voyager dengan atribusi', (tester) async {
    await _pumpPreview(tester, _firstVenue);
    await tester.pump();

    final tile = tester.widget<TileLayer>(find.byType(TileLayer));
    expect(tile.urlTemplate, BasemapUrl.tileTemplate(AppConstants.basemapKey));
    expect(tile.urlTemplate, contains('cartocdn'));
    expect(tile.urlTemplate, contains('{s}'));
    expect(tile.urlTemplate, contains('{r}'));
    expect(tile.urlTemplate, contains('key='));
    expect(tile.subdomains, <String>['a', 'b', 'c', 'd']);
    expect(tile.resolvedRetinaMode, RetinaMode.server);
    final tileFilter = find.byWidgetPredicate(
      (widget) => widget is ColorFiltered && widget.child is TileLayer,
    );
    expect(tileFilter, findsOneWidget);
    expect(tester.widget<ColorFiltered>(tileFilter).colorFilter, isNotNull);

    // Nada CARTO dipetakan ke rata-rata OSM tanpa memotong piksel terang.
    const matrix = VenueMapPreview.tileColorMatrix;
    expect(matrix[0], 1.1);
    expect(matrix[4], closeTo(-50.5, 0.01));
    expect(matrix[9], closeTo(-47, 0.01));
    expect(matrix[14], closeTo(-39.9, 0.01));
    expect(find.byType(RichAttributionWidget), findsOneWidget);
  });

  testWidgets('popup atribusi bisa dibuka lalu ditutup', (tester) async {
    await _pumpPreview(tester, _firstVenue);
    await tester.pump();

    await tester.tap(find.byTooltip('Atribusi peta'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
    expect(find.text('© CARTO'), findsOneWidget);

    await tester.tap(find.byTooltip('Tutup atribusi'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byTooltip('Atribusi peta'), findsOneWidget);
  });

  testWidgets('tanpa rute tidak ada polyline maupun titik asal', (
    tester,
  ) async {
    await _pumpPreview(tester, _firstVenue);
    await tester.pump();

    expect(find.byType(PolylineLayer), findsNothing);
    expect(find.byKey(const Key('venue_route_origin')), findsNothing);
  });

  testWidgets('rute dengan kurang dari dua titik diabaikan', (tester) async {
    const shortRoute = RoutePath(points: [LatLng(-6.1, 106.7)]);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueMapPreview(
            latitude: _firstVenue.latitude,
            longitude: _firstVenue.longitude,
            route: shortRoute,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PolylineLayer), findsNothing);
    expect(find.byKey(const Key('venue_route_origin')), findsNothing);
  });
}
