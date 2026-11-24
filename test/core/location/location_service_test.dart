import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rumahkicau_mobile/core/location/geolocator_location_service.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';

/// Platform geolocator palsu untuk menguji jalur pembaca bawaan.
class FakeGeolocatorPlatform extends GeolocatorPlatform {
  FakeGeolocatorPlatform(this.position);

  final Position position;
  LocationSettings? recordedSettings;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    recordedSettings = locationSettings;
    return position;
  }
}

void main() {
  final position = Position(
    longitude: 106.8,
    latitude: -6.2,
    timestamp: DateTime.utc(2026),
    accuracy: 12.4,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  GeolocatorLocationService buildService({
    bool enabled = true,
    LocationPermission permission = LocationPermission.always,
    LocationPermission requested = LocationPermission.always,
    PositionReader? readPosition,
  }) {
    return GeolocatorLocationService(
      isLocationServiceEnabled: () async => enabled,
      checkPermission: () async => permission,
      requestPermission: () async => requested,
      readPosition: readPosition ?? () async => position,
    );
  }

  test('service demo tidak menghasilkan koordinat', () async {
    const createService = NoLocationService.new;
    expect(await const NoLocationService().readCurrentLocation(), isNull);
    expect(await createService().readCurrentLocation(), isNull);
  });

  test('layanan mati mengembalikan null tanpa meminta izin', () async {
    final service = buildService(enabled: false);

    expect(await service.readCurrentLocation(), isNull);
  });

  test('izin ditolak permanen mengembalikan null', () async {
    final service = buildService(permission: LocationPermission.deniedForever);

    expect(await service.readCurrentLocation(), isNull);
  });

  test('izin ditolak lalu masih ditolak mengembalikan null', () async {
    final service = buildService(
      permission: LocationPermission.denied,
      requested: LocationPermission.denied,
    );

    expect(await service.readCurrentLocation(), isNull);
  });

  test(
    'izin diberikan menghasilkan koordinat dengan akurasi dibulatkan',
    () async {
      final location = await buildService().readCurrentLocation();

      expect(
        location,
        const DeviceLocation(latitude: -6.2, longitude: 106.8, accuracyM: 12),
      );
    },
  );

  test('izin diminta ulang lalu diberikan menghasilkan koordinat', () async {
    final service = buildService(
      permission: LocationPermission.denied,
      requested: LocationPermission.whileInUse,
    );

    expect(await service.readCurrentLocation(), isNotNull);
  });

  test('pembaca bawaan memakai pengaturan akurasi sedang', () async {
    final original = GeolocatorPlatform.instance;
    final platform = FakeGeolocatorPlatform(position);
    GeolocatorPlatform.instance = platform;
    addTearDown(() => GeolocatorPlatform.instance = original);

    final service = GeolocatorLocationService(
      isLocationServiceEnabled: () async => true,
      checkPermission: () async => LocationPermission.always,
    );

    expect(await service.readCurrentLocation(), isNotNull);
    expect(platform.recordedSettings?.accuracy, LocationAccuracy.medium);
  });
}
