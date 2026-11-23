/// Pembangun URL tile CARTO Voyager.
///
/// Placeholder `{s}` (subdomain) dan `{r}` (retina `@2x`) diganti `flutter_map`.
/// API key disuntikkan lewat `--dart-define=CARTO_BASEMAP_KEY=...` dari
/// `env/secrets.json`; nilainya tidak pernah ditanam di source.
abstract final class BasemapUrl {
  /// Template tile Voyager dengan key dari environment.
  static String tileTemplate(String key) =>
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/'
      '{z}/{x}/{y}{r}.png?key=$key';
}
