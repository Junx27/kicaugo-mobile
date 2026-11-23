import '../../../../core/location/location_service.dart';
import '../repositories/current_location_repository.dart';

/// Usecase menyimpan lokasi terkini agar pencarian event memakai koordinatnya.
class UpdateCurrentLocation {
  const UpdateCurrentLocation(this._repository);

  final CurrentLocationRepository _repository;

  Future<void> call(DeviceLocation location) =>
      _repository.updateCurrentLocation(location);
}
