/// Pembangun URL tile peta lewat backend (proxy CARTO).
///
/// Token Bearer TIDAK ditanam di URL; diset lewat `NetworkTileProvider.headers`.
/// `apiBaseUrl` diambil dari `AppConstants.apiBaseUrl`.
abstract final class BasemapUrl {
  const BasemapUrl._();

  /// Template tile backend. Placeholder `{z}/{x}/{y}` diganti `flutter_map`.
  static String tileTemplate(String apiBaseUrl) =>
      '$apiBaseUrl/api/v1/basemap/tiles/{z}/{x}/{y}';
}
