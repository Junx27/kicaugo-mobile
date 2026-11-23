import '../../../../core/location/location_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import 'current_location_data_source.dart';

/// Menulis lokasi terkini ke `PUT /me/profile/current-location`.
class ApiCurrentLocationDataSource implements CurrentLocationDataSource {
  const ApiCurrentLocationDataSource(this._client);

  final ApiClient _client;

  @override
  Future<void> updateCurrentLocation(DeviceLocation location) async {
    await _client.putJson(
      ApiPaths.meProfileCurrentLocation,
      body: <String, dynamic>{
        'latitude': location.latitude,
        'longitude': location.longitude,
        'accuracy_m': location.accuracyM,
      },
    );
  }
}
