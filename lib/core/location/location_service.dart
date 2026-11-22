import 'package:equatable/equatable.dart';

/// Koordinat perangkat yang dikirim ke backend untuk pencarian event terdekat.
class DeviceLocation extends Equatable {
  const DeviceLocation({
    required this.latitude,
    required this.longitude,
    this.accuracyM,
  });

  final double latitude;
  final double longitude;
  final int? accuracyM;

  @override
  List<Object?> get props => <Object?>[latitude, longitude, accuracyM];
}

/// Kontrak pembaca lokasi terkini, diganti dengan fake saat menguji.
abstract class LocationService {
  /// Mengembalikan null bila lokasi tidak tersedia atau izin ditolak.
  Future<DeviceLocation?> readCurrentLocation();
}

/// Pembaca lokasi untuk mode demo: tidak pernah menghasilkan koordinat.
class NoLocationService implements LocationService {
  const NoLocationService();

  @override
  Future<DeviceLocation?> readCurrentLocation() async => null;
}
