import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/network/token_provider.dart';
import 'package:rumahkicau_mobile/core/routing/route_service.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/theme/app_text_styles.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/utils/basemap_url.dart';
import 'package:rumahkicau_mobile/core/widgets/status_dot.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/session_storage.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opsi tampilan dan kontrol untuk [VenueMapPreview].
class VenueMapOptions {
  const VenueMapOptions({
    this.height = 160,
    this.interactive = false,
    this.borderRadius,
    this.onTap,
    this.controller,
    this.markerLabel,
    this.showMarkerLabel = true,
    this.onMarkerTap,
    this.onReady,
  });

  final double height;
  final bool interactive;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  /// Controller eksternal untuk kontrol zoom/recenter dari halaman induk.
  final MapController? controller;

  /// Label venue di atas pin; `null` memakai pin polos.
  final String? markerLabel;

  /// Label disembunyikan saat sheet detail sedang terlihat.
  final bool showMarkerLabel;

  /// Dipanggil saat pin diketuk, misalnya untuk membuka kembali detail.
  final VoidCallback? onMarkerTap;

  /// Diberitahu saat peta pertama kali siap dipakai lewat controller.
  final VoidCallback? onReady;
}

/// Preview peta in-app untuk lokasi venue lomba.
///
/// Menampilkan peta, marker venue, dan bila [route] tersedia, garis rute dari
/// lokasi pengguna ke venue. Navigasi turn-by-turn tetap lewat aplikasi peta
/// native.
class VenueMapPreview extends StatefulWidget {
  const VenueMapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    this.options = const VenueMapOptions(),
    this.route,
    this.tokenProvider,
  });

  final double latitude;
  final double longitude;
  final VenueMapOptions options;
  final RoutePath? route;

  /// Sumber token Bearer (opsional). Bila null, widget mencoba `getIt<SessionStorage>`.
  final TokenProvider? tokenProvider;

  /// Zoom awal peta; dipakai tombol "orientasi" halaman untuk reset tampilan.
  /// Satu level di atas 14 menampilkan lebih banyak detail jalan di preview.
  static const double defaultZoom = 15;

  @override
  State<VenueMapPreview> createState() => _VenueMapPreviewState();
}

class _VenueMapPreviewState extends State<VenueMapPreview> {
  late final MapController _controller;
  late final bool _ownsController;
  bool _mapReady = false;

  NetworkTileProvider? _tileProvider;
  String? _tileProviderToken;

  @override
  void initState() {
    super.initState();
    final external = widget.options.controller;
    _ownsController = external == null;
    _controller = external ?? MapController();
    _rebuildTileProvider(_resolveToken(widget.tokenProvider));
  }

  @override
  void didUpdateWidget(covariant VenueMapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude;
    // Sebelum frame pertama, `initialCenter` baru akan dipakai saat render.
    if (!changed || !_mapReady) {
      // Token bisa berubah tanpa perubahan koordinat.
      final newToken = _resolveToken(widget.tokenProvider);
      if (newToken != _tileProviderToken) {
        _rebuildTileProvider(newToken);
      }
      return;
    }
    _controller.move(
      LatLng(widget.latitude, widget.longitude),
      _controller.camera.zoom,
    );
    final newToken = _resolveToken(widget.tokenProvider);
    if (newToken != _tileProviderToken) {
      _rebuildTileProvider(newToken);
    }
  }

  @override
  void dispose() {
    _tileProvider?.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  String? _resolveToken(TokenProvider? provider) {
    if (provider != null) return provider.accessToken;
    try {
      return GetIt.I<SessionStorage>().accessToken;
    } catch (_) {
      return null;
    }
  }

  void _rebuildTileProvider(String? token) {
    _tileProvider?.dispose();
    final headers = <String, String>{
      'User-Agent': 'com.kicaugo.mobile',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    _tileProvider = NetworkTileProvider(headers: headers);
    _tileProviderToken = token;
  }

  void _handleMapReady() {
    _mapReady = true;
    widget.options.onReady?.call();
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(widget.latitude, widget.longitude);
    final options = widget.options;
    final radius =
        options.borderRadius ?? BorderRadius.circular(AppTheme.cardRadius);
    final label = options.markerLabel;
    final showLabel = label != null && options.showMarkerLabel;
    final routePoints = widget.route?.points ?? const <LatLng>[];
    final hasRoute = routePoints.length >= 2;
    final map = ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: options.height,
        child: FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: center,
            initialZoom: VenueMapPreview.defaultZoom,
            maxZoom: 20,
            onMapReady: _handleMapReady,
            interactionOptions: InteractionOptions(
              flags: options.interactive
                  ? InteractiveFlag.all
                  : InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: BasemapUrl.tileTemplate(AppConstants.apiBaseUrl),
              tileProvider: _tileProvider,
              subdomains: const <String>[],
              retinaMode: RetinaMode.isHighDensity(context),
              maxZoom: 20,
              maxNativeZoom: 18,
              userAgentPackageName: 'com.kicaugo.mobile',
            ),
            if (hasRoute)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    color: AppColors.blueStrong,
                    strokeWidth: 4,
                    borderColor: AppColors.surface,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (hasRoute)
                  Marker(
                    point: routePoints.first,
                    width: 22,
                    height: 22,
                    child: const _OriginDot(),
                  ),
                Marker(
                  point: center,
                  width: showLabel ? 180 : 40,
                  height: showLabel ? 96 : 40,
                  alignment: showLabel
                      ? Alignment.bottomCenter
                      : Alignment.center,
                  child: label == null
                      ? const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.onPink,
                          size: 36,
                        )
                      : _VenuePin(
                          label: label,
                          showLabel: showLabel,
                          onTap: options.onMarkerTap,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    const attribution = Positioned(
      right: 8,
      bottom: 4,
      child: _MapAttribution(),
    );

    final onTap = options.onTap;
    if (onTap == null) {
      return Stack(children: [map, attribution]);
    }

    // FlutterMap memiliki gesture recognizer sendiri, jadi lapisan transparan
    // di atasnya yang menangkap tap untuk membuka halaman penuh.
    // Atribusi diletakkan DI ATAS overlay agar tetap bisa diklik (kanan bawah).
    return Stack(
      children: [
        map,
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
          ),
        ),
        attribution,
      ],
    );
  }
}

/// Pin venue dengan label melayang dan riak lembut seperti desain.
class _VenuePin extends StatelessWidget {
  const _VenuePin({required this.label, required this.showLabel, this.onTap});

  final String label;
  final bool showLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const pin = SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Ripple(size: 40, alpha: 0.25),
          _Ripple(size: 26, alpha: 0.35),
          Icon(Icons.location_on_rounded, color: AppColors.error, size: 40),
        ],
      ),
    );

    if (!showLabel) {
      return GestureDetector(
        key: const Key('venue_pin'),
        onTap: onTap,
        child: pin,
      );
    }

    return GestureDetector(
      key: const Key('venue_pin'),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            key: const Key('venue_pin_label'),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              boxShadow: AppTheme.softShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                const StatusDot(
                  key: Key('venue_pin_dot'),
                  color: AppColors.pinkStrong,
                ),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          pin,
        ],
      ),
    );
  }
}

class _Ripple extends StatelessWidget {
  const _Ripple({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: alpha),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Titik asal rute (lokasi pengguna) biru dengan tepi putih, senada garis rute.
class _OriginDot extends StatelessWidget {
  const _OriginDot();

  static const double _borderWidth = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('venue_route_origin'),
      decoration: BoxDecoration(
        color: AppColors.blueStrong,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.surface,
          width: _OriginDot._borderWidth,
        ),
      ),
    );
  }
}

/// Atribusi CARTO/OSM yang selalu terlihat (tidak disembunyikan di popup)
/// dan dapat diklik.
class _MapAttribution extends StatelessWidget {
  const _MapAttribution();

  static const String _osmUrl = 'https://www.openstreetmap.org/copyright';
  static const String _cartoUrl = 'https://carto.com/attribution/';

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _open(_osmUrl),
              child: const Text(
                '© OpenStreetMap contributors',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
            const Text(
              ', ',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
            GestureDetector(
              onTap: () => _open(_cartoUrl),
              child: const Text(
                '© CARTO',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
