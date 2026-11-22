import '../../../../core/location/location_service.dart';

/// Kontrak penulisan lokasi terkini pengguna ke backend.
abstract class CurrentLocationRepository {
  Future<void> updateCurrentLocation(DeviceLocation location);
}
