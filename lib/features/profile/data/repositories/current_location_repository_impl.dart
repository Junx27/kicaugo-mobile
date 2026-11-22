import '../../../../core/location/location_service.dart';
import '../../domain/repositories/current_location_repository.dart';
import '../datasources/current_location_data_source.dart';

/// Implementasi repository lokasi di atas [CurrentLocationDataSource].
class CurrentLocationRepositoryImpl implements CurrentLocationRepository {
  const CurrentLocationRepositoryImpl(this._dataSource);

  final CurrentLocationDataSource _dataSource;

  @override
  Future<void> updateCurrentLocation(DeviceLocation location) =>
      _dataSource.updateCurrentLocation(location);
}
