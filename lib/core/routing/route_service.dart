import 'package:latlong2/latlong.dart';

/// Hasil perhitungan rute antara lokasi pengguna dan venue.
class RoutePath {
  const RoutePath({required this.points, this.distanceM, this.durationS});

  /// Titik-titik garis rute, berurutan dari origin ke tujuan.
  final List<LatLng> points;

  /// Panjang rute dalam meter; null bila provider tidak mengirim.
  final double? distanceM;

  /// Perkiraan waktu tempuh dalam detik; null bila provider tidak mengirim.
  final double? durationS;
}

/// Kontrak penyedia rute; implementasi bisa OSRM, OpenRouteService, atau
/// proxy backend, sehingga provider dapat diganti tanpa menyentuh UI.
abstract class RouteService {
  /// Mengembalikan null bila rute tidak bisa dihitung (offline, kuota habis,
  /// atau respons provider tidak valid).
  Future<RoutePath?> fetchRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  });
}
