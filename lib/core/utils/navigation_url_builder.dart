import 'dart:core';

/// Membangun URL navigasi eksternal ke aplikasi peta native.
///
/// Prioritas tujuan: koordinat venue. Bila tidak tersedia, gunakan query teks
/// (nama venue/alamat). Origin (lokasi pengguna) hanya ditambahkan bila kedua
/// koordinat origin tersedia.
String? buildExternalNavigationUrl({
  double? originLatitude,
  double? originLongitude,
  double? destinationLatitude,
  double? destinationLongitude,
  String? destinationQuery,
}) {
  final hasDestinationCoordinates =
      destinationLatitude != null && destinationLongitude != null;
  if (hasDestinationCoordinates) {
    final destination = '$destinationLatitude,$destinationLongitude';
    final hasOriginCoordinates =
        originLatitude != null && originLongitude != null;
    final origin = hasOriginCoordinates
        ? '$originLatitude,$originLongitude'
        : null;
    final parameters = <String, String>{'api': '1', 'destination': destination};
    if (origin != null) {
      parameters['origin'] = origin;
    }
    return Uri.https('www.google.com', '/maps/dir/', parameters).toString();
  }

  final query = destinationQuery?.trim();
  if (query != null && query.isNotEmpty) {
    return Uri.https('www.google.com', '/maps/search/', <String, String>{
      'api': '1',
      'query': query,
    }).toString();
  }

  return null;
}
