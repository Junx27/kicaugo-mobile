import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/core/network/api_paths.dart';
import 'package:rumahkicau_mobile/features/profile/data/datasources/api_current_location_data_source.dart';
import 'package:rumahkicau_mobile/features/profile/data/datasources/current_location_data_source.dart';
import 'package:rumahkicau_mobile/features/profile/data/repositories/current_location_repository_impl.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/update_current_location.dart';

import '../../../support/fake_http.dart';
import '../../../support/fakes.dart';

const DeviceLocation sampleLocation = DeviceLocation(
  latitude: -6.2,
  longitude: 106.8,
  accuracyM: 12,
);

/// Sumber data pencatat untuk menguji delegasi repository.
class RecordingLocationDataSource implements CurrentLocationDataSource {
  final List<DeviceLocation> updates = <DeviceLocation>[];

  @override
  Future<void> updateCurrentLocation(DeviceLocation location) async {
    updates.add(location);
  }
}

void main() {
  test(
    'sumber data API mengirim koordinat dan akurasi dengan Bearer',
    () async {
      final adapter = FakeHttpAdapter();
      final client = ApiClient(
        testDio(adapter),
        FakeTokenProvider('jwt-token'),
      );

      await ApiCurrentLocationDataSource(
        client,
      ).updateCurrentLocation(sampleLocation);

      expect(adapter.recordedOptions?.method, 'PUT');
      expect(adapter.recordedOptions?.path, ApiPaths.meProfileCurrentLocation);
      expect(
        adapter.recordedOptions?.headers['Authorization'],
        'Bearer jwt-token',
      );
      expect(recordedBody(adapter), <String, dynamic>{
        'latitude': -6.2,
        'longitude': 106.8,
        'accuracy_m': 12,
      });
    },
  );

  test('sumber data demo tidak menyimpan lokasi', () async {
    await expectLater(
      const NoOpCurrentLocationDataSource().updateCurrentLocation(
        sampleLocation,
      ),
      completes,
    );
  });

  test('repository meneruskan lokasi ke sumber data', () async {
    final dataSource = RecordingLocationDataSource();

    await CurrentLocationRepositoryImpl(
      dataSource,
    ).updateCurrentLocation(sampleLocation);

    expect(dataSource.updates, <DeviceLocation>[sampleLocation]);
  });

  test('usecase meneruskan lokasi ke repository', () async {
    final repository = FakeCurrentLocationRepository();

    await UpdateCurrentLocation(repository).call(sampleLocation);

    expect(repository.updates, <DeviceLocation>[sampleLocation]);
  });
}
