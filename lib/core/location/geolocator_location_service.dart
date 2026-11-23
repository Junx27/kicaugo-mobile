import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

/// Fungsi platform yang diinjeksikan agar cabang izin dapat diuji.
typedef LocationAvailability = Future<bool> Function();
typedef LocationPermissionReader = Future<LocationPermission> Function();
typedef PositionReader = Future<Position> Function();

/// Membaca lokasi terkini perangkat lewat plugin geolocator.
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService({
    this.isLocationServiceEnabled = Geolocator.isLocationServiceEnabled,
    this.checkPermission = Geolocator.checkPermission,
    this.requestPermission = Geolocator.requestPermission,
    this.readPosition = _readPlatformPosition,
  });

  final LocationAvailability isLocationServiceEnabled;
  final LocationPermissionReader checkPermission;
  final LocationPermissionReader requestPermission;
  final PositionReader readPosition;

  /// Akurasi sedang cukup untuk jarak event dan hemat baterai.
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.medium,
    timeLimit: Duration(seconds: 10),
  );

  static Future<Position> _readPlatformPosition() =>
      Geolocator.getCurrentPosition(locationSettings: _settings);

  @override
  Future<DeviceLocation?> readCurrentLocation() async {
    if (!await isLocationServiceEnabled()) return null;

    final permission = await _resolvePermission();
    if (permission == null) return null;

    final position = await readPosition();
    return DeviceLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyM: position.accuracy.round(),
    );
  }

  /// Mengembalikan null bila izin ditolak atau ditolak permanen.
  Future<LocationPermission?> _resolvePermission() async {
    var permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return permission;
  }
}
