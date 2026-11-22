import '../../../../core/location/location_service.dart';

/// Kontrak sumber data penulisan lokasi terkini.
abstract class CurrentLocationDataSource {
  Future<void> updateCurrentLocation(DeviceLocation location);
}

/// Sumber data demo yang tidak menyimpan lokasi ke mana pun.
class NoOpCurrentLocationDataSource implements CurrentLocationDataSource {
  const NoOpCurrentLocationDataSource();

  @override
  Future<void> updateCurrentLocation(DeviceLocation location) async {}
}
