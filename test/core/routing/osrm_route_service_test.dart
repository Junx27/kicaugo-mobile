import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumahkicau_mobile/core/routing/osrm_route_service.dart';
import 'package:rumahkicau_mobile/core/routing/route_service.dart';

/// Adapter HTTP palsu: merekam request dan mengembalikan respons yang diatur.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter({
    this.body = const <String, dynamic>{},
    this.statusCode = 200,
    this.error,
  });

  final Object body;
  final int statusCode;
  final Object? error;
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (error != null) throw error!;
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Respons OSRM valid; koordinat GeoJSON berurutan [longitude, latitude].
Map<String, dynamic> osrmResponse({Object? geometry, List<Object?>? routes}) =>
    <String, dynamic>{
      'code': 'Ok',
      'routes':
          routes ??
          <Object?>[
            <String, dynamic>{
              'distance': 2400.0,
              'duration': 600.0,
              'geometry':
                  geometry ??
                  <String, dynamic>{
                    'coordinates': <Object?>[
                      <double>[106.7, -6.1],
                      <double>[106.75, -6.15],
                      <double>[106.8, -6.2],
                    ],
                  },
            },
          ],
    };

OsrmRouteService serviceWith(FakeAdapter adapter) =>
    OsrmRouteService(dio: Dio()..httpClientAdapter = adapter);

Future<RoutePath?> fetchSample(RouteService service) => service.fetchRoute(
  originLatitude: -6.1,
  originLongitude: 106.7,
  destinationLatitude: -6.2,
  destinationLongitude: 106.8,
);

void main() {
  test('konstruktor bawaan membuat Dio sendiri tanpa jaringan', () {
    expect(OsrmRouteService(), isA<RouteService>());
  });

  test('rute valid diurai dan URL memakai urutan lon,lat', () async {
    final adapter = FakeAdapter(body: osrmResponse());
    final route = await fetchSample(serviceWith(adapter));

    final uri = adapter.requests.single.uri;
    expect(uri.host, 'router.project-osrm.org');
    // Jebakan utama OSRM: longitude dulu, baru latitude.
    expect(uri.path, contains('106.7,-6.1;106.8,-6.2'));
    expect(uri.queryParameters['overview'], 'full');
    expect(uri.queryParameters['geometries'], 'geojson');

    expect(route, isNotNull);
    expect(route!.points, const [
      LatLng(-6.1, 106.7),
      LatLng(-6.15, 106.75),
      LatLng(-6.2, 106.8),
    ]);
    expect(route.distanceM, 2400);
    expect(route.durationS, 600);
  });

  test('kode respons bukan Ok menghasilkan null', () async {
    final body = osrmResponse()..['code'] = 'NoRoute';
    expect(await fetchSample(serviceWith(FakeAdapter(body: body))), isNull);
  });

  test('daftar routes kosong menghasilkan null', () async {
    final body = osrmResponse(routes: <Object?>[]);
    expect(await fetchSample(serviceWith(FakeAdapter(body: body))), isNull);
  });

  test('elemen routes bukan objek menghasilkan null', () async {
    final body = osrmResponse(routes: <Object?>['rusak']);
    expect(await fetchSample(serviceWith(FakeAdapter(body: body))), isNull);
  });

  test('geometry bukan objek menghasilkan null', () async {
    final body = osrmResponse(geometry: 'rusak');
    expect(await fetchSample(serviceWith(FakeAdapter(body: body))), isNull);
  });

  test('coordinates bukan daftar menghasilkan null', () async {
    final body = osrmResponse(
      geometry: <String, dynamic>{'coordinates': 'rusak'},
    );
    expect(await fetchSample(serviceWith(FakeAdapter(body: body))), isNull);
  });

  test('koordinat rusak dilewati, yang valid tetap dipakai', () async {
    final body = osrmResponse(
      geometry: <String, dynamic>{
        'coordinates': <Object?>[
          <double>[106.7, -6.1],
          'rusak',
          <double>[106.75],
          <String>['a', 'b'],
          <double>[106.8, -6.2],
        ],
      },
    );
    final route = await fetchSample(serviceWith(FakeAdapter(body: body)));

    expect(route!.points, const [LatLng(-6.1, 106.7), LatLng(-6.2, 106.8)]);
  });

  test('kurang dari dua titik valid menghasilkan null', () async {
    final body = osrmResponse(
      geometry: <String, dynamic>{
        'coordinates': <Object?>[
          <double>[106.7, -6.1],
        ],
      },
    );
    expect(await fetchSample(serviceWith(FakeAdapter(body: body))), isNull);
  });

  test('jarak dan durasi opsional boleh tidak ada', () async {
    final body = osrmResponse();
    final route = (body['routes'] as List).first as Map<String, dynamic>
      ..remove('distance')
      ..remove('duration');
    expect(route.containsKey('distance'), isFalse);

    final result = await fetchSample(serviceWith(FakeAdapter(body: body)));
    expect(result!.distanceM, isNull);
    expect(result.durationS, isNull);
  });

  test('respons bukan objek JSON menghasilkan null', () async {
    final adapter = FakeAdapter(body: <Object?>[1, 2]);
    expect(await fetchSample(serviceWith(adapter)), isNull);
  });

  test('status HTTP gagal menghasilkan null', () async {
    final adapter = FakeAdapter(body: osrmResponse(), statusCode: 500);
    expect(await fetchSample(serviceWith(adapter)), isNull);
  });

  test('jaringan error menghasilkan null', () async {
    final adapter = FakeAdapter(error: Exception('offline'));
    expect(await fetchSample(serviceWith(adapter)), isNull);
  });
}
