import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../location/geolocator_location_service.dart';
import '../location/location_service.dart';
import '../widgets/app_snack_bar.dart';
import 'navigation_url_builder.dart';

/// Pemeriksa ketersediaan aplikasi tujuan; dapat diganti di test.
typedef LaunchChecker = Future<bool> Function(Uri uri);

/// Peluncur aplikasi eksternal; dapat diganti di test.
typedef UrlLauncher = Future<bool> Function(Uri uri, LaunchMode mode);

/// Membuka aplikasi peta native menuju koordinat venue.
///
/// Origin diambil lewat [LocationService] yang sudah menangani izin dan batas
/// waktu. Bila lokasi tidak tersedia, navigasi tetap berjalan tanpa origin dan
/// pengguna diberi tahu. Bila koordinat venue tidak ada, tujuan fallback ke
/// [destinationQuery].
Future<void> openExternalNavigation({
  required BuildContext context,
  double? destinationLatitude,
  double? destinationLongitude,
  required String destinationQuery,
  LocationService? locationService,
  LaunchChecker? canLaunch,
  UrlLauncher? launch,
}) async {
  final service = locationService ?? const GeolocatorLocationService();
  final launchChecker = canLaunch ?? canLaunchUrl;
  final urlLauncher = launch ?? (uri, mode) => launchUrl(uri, mode: mode);

  DeviceLocation? location;
  try {
    location = await service.readCurrentLocation();
  } catch (_) {
    // Layanan lokasi tidak tersedia; lanjut tanpa origin.
    location = null;
  }

  final url = buildExternalNavigationUrl(
    originLatitude: location?.latitude,
    originLongitude: location?.longitude,
    destinationLatitude: destinationLatitude,
    destinationLongitude: destinationLongitude,
    destinationQuery: destinationQuery,
  );
  if (url == null) {
    if (context.mounted) {
      showComingSoon(context);
    }
    return;
  }

  if (location == null && context.mounted) {
    showAppSnackBar(context, AppConstants.navigationOriginUnavailable);
  }

  final uri = Uri.parse(url);
  if (await launchChecker(uri)) {
    await urlLauncher(uri, LaunchMode.externalApplication);
  } else if (context.mounted) {
    showComingSoon(context);
  }
}
