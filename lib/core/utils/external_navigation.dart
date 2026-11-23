import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_snack_bar.dart';
import 'navigation_url_builder.dart';

/// Pembaca posisi pengguna; dapat diganti di test tanpa izin sistem.
typedef PositionReader = Future<Position> Function();

/// Pemeriksa ketersediaan aplikasi tujuan; dapat diganti di test.
typedef LaunchChecker = Future<bool> Function(Uri uri);

/// Peluncur aplikasi eksternal; dapat diganti di test.
typedef UrlLauncher = Future<bool> Function(Uri uri, LaunchMode mode);

/// Membuka aplikasi peta native menuju koordinat venue.
///
/// Origin diambil dari lokasi pengguna bila tersedia. Bila koordinat venue
/// tidak ada, tujuan fallback ke [destinationQuery]. Kegagalan izin lokasi
/// tidak membatalkan navigasi.
Future<void> openExternalNavigation({
  required BuildContext context,
  double? destinationLatitude,
  double? destinationLongitude,
  required String destinationQuery,
  PositionReader? readPosition,
  LaunchChecker? canLaunch,
  UrlLauncher? launch,
}) async {
  final positionReader = readPosition ?? () => Geolocator.getCurrentPosition();
  final launchChecker = canLaunch ?? canLaunchUrl;
  final urlLauncher = launch ?? (uri, mode) => launchUrl(uri, mode: mode);

  double? originLatitude;
  double? originLongitude;
  try {
    final position = await positionReader();
    originLatitude = position.latitude;
    originLongitude = position.longitude;
  } catch (_) {
    // Izin ditolak atau layanan lokasi tidak tersedia; lanjut tanpa origin.
  }

  final url = buildExternalNavigationUrl(
    originLatitude: originLatitude,
    originLongitude: originLongitude,
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

  final uri = Uri.parse(url);
  if (await launchChecker(uri)) {
    await urlLauncher(uri, LaunchMode.externalApplication);
  } else if (context.mounted) {
    showComingSoon(context);
  }
}
