import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../constants/app_constants.dart';
import 'route_service.dart';

/// Penghitung rute memakai server demo OSRM (gratis, tanpa API key).
///
/// Server demo hanya untuk pengembangan/demo, bukan produksi. Untuk rilis,
/// ganti dengan provider ber-key atau proxy backend lewat [RouteService].
class OsrmRouteService implements RouteService {
  OsrmRouteService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: AppConstants.apiTimeout,
              receiveTimeout: AppConstants.apiTimeout,
              responseType: ResponseType.json,
            ),
          );

  static const String _host = 'router.project-osrm.org';

  final Dio _dio;

  @override
  Future<RoutePath?> fetchRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    try {
      final response = await _dio.getUri<Object>(
        _routeUri(
          originLatitude: originLatitude,
          originLongitude: originLongitude,
          destinationLatitude: destinationLatitude,
          destinationLongitude: destinationLongitude,
        ),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) return null;
      return _parseRoute(data);
    } catch (_) {
      // Offline, timeout, atau respons rusak: biar UI yang memberi tahu user.
      return null;
    }
  }

  /// OSRM memakai urutan longitude,latitude — kebalikan dari [LatLng].
  static Uri _routeUri({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) {
    final origin = '$originLongitude,$originLatitude';
    final destination = '$destinationLongitude,$destinationLatitude';
    return Uri.https(_host, '/route/v1/driving/$origin;$destination', const {
      'overview': 'full',
      'geometries': 'geojson',
    });
  }

  static RoutePath? _parseRoute(Map<String, dynamic> data) {
    final routes = data['routes'];
    if (data['code'] != 'Ok' || routes is! List || routes.isEmpty) return null;
    final route = routes.first;
    if (route is! Map) return null;
    final points = _parsePoints(route['geometry']);
    if (points.length < 2) return null;
    return RoutePath(
      points: points,
      distanceM: (route['distance'] as num?)?.toDouble(),
      durationS: (route['duration'] as num?)?.toDouble(),
    );
  }

  /// GeoJSON menyimpan koordinat sebagai [longitude, latitude]; dibalik di
  /// sini agar garis tidak muncul di lokasi yang salah.
  static List<LatLng> _parsePoints(Object? geometry) {
    if (geometry is! Map) return const [];
    final coordinates = geometry['coordinates'];
    if (coordinates is! List) return const [];
    final points = <LatLng>[];
    for (final coordinate in coordinates) {
      if (coordinate is! List || coordinate.length < 2) continue;
      final lon = coordinate[0];
      final lat = coordinate[1];
      if (lon is num && lat is num) {
        points.add(LatLng(lat.toDouble(), lon.toDouble()));
      }
    }
    return points;
  }
}
