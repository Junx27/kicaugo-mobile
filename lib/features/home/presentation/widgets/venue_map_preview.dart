import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/basemap_url.dart';
import '../../../../core/widgets/status_dot.dart';

/// Transformasi warna tile CARTO agar nadanya mendekati tile OSM publik.
///
/// Rata-rata sampel CARTO (245,240,229) dipetakan ke rata-rata OSM
/// (219,217,212). Kemiringan 1.10 menjaga label dan tepi jalan tetap tajam;
/// offset per kanal menggelapkan sekaligus mengurangi kehangatan CARTO.
/// Pendekatan lama `1.5x - 64` memusatkan kontras pada 128 dan membuat hampir
/// semua piksel tile terang ter-clip ke putih.
const double _tileColorGain = 1.1;
const double _tileRedOffset = 219 - _tileColorGain * 245;
const double _tileGreenOffset = 217 - _tileColorGain * 240;
const double _tileBlueOffset = 212 - _tileColorGain * 229;
const ColorFilter _tileColorFilter = ColorFilter.matrix(
  VenueMapPreview.tileColorMatrix,
);

/// Ukuran tombol atribusi ringkas agar tidak menutupi preview 160 px.
const double _attributionIconSize = 16;
const double _attributionButtonSize = 24;

/// Tombol buka/tutup popup atribusi dengan ukuran yang seragam.
Widget _attributionButton({
  required IconData icon,
  required String tooltip,
  required VoidCallback onPressed,
}) {
  return IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(
      icon,
      size: _attributionIconSize,
      color: AppColors.textSecondary,
    ),
    visualDensity: VisualDensity.compact,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints.tightFor(
      width: _attributionButtonSize,
      height: _attributionButtonSize,
    ),
  );
}

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
  });

  final double latitude;
  final double longitude;
  final VenueMapOptions options;

  /// Rute dari lokasi pengguna ke venue; null berarti tidak digambar.
  final RoutePath? route;

  /// Zoom awal peta; dipakai tombol "orientasi" halaman untuk reset tampilan.
  /// Satu level di atas 14 menampilkan lebih banyak detail jalan di preview.
  static const double defaultZoom = 15;

  /// Matrix warna tile CARTO yang disamakan ke nada OSM. Diekspos sebagai
  /// token tema supaya test bisa mengunci nilainya.
  static const List<double> tileColorMatrix = <double>[
    _tileColorGain,
    0,
    0,
    0,
    _tileRedOffset,
    0,
    _tileColorGain,
    0,
    0,
    _tileGreenOffset,
    0,
    0,
    _tileColorGain,
    0,
    _tileBlueOffset,
    0,
    0,
    0,
    1,
    0,
  ];

  static const double _routeStrokeWidth = 4;
  static const double _routeBorderWidth = 2;
  static const double _originMarkerSize = 22;

  @override
  State<VenueMapPreview> createState() => _VenueMapPreviewState();
}

class _VenueMapPreviewState extends State<VenueMapPreview> {
  /// `initialCenter` hanya dipakai FlutterMap saat pertama kali dibuat, jadi
  /// perubahan koordinat setelah itu harus memindahkan kamera lewat controller.

  late final MapController _controller;
  late final bool _ownsController;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    final external = widget.options.controller;
    _ownsController = external == null;
    _controller = external ?? MapController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VenueMapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude;
    // Sebelum frame pertama, `initialCenter` baru akan dipakai saat render.
    if (!changed || !_mapReady) return;
    _controller.move(
      LatLng(widget.latitude, widget.longitude),
      _controller.camera.zoom,
    );
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
            onMapReady: _handleMapReady,
            interactionOptions: InteractionOptions(
              flags: options.interactive
                  ? InteractiveFlag.all
                  : InteractiveFlag.none,
            ),
          ),
          children: [
            ColorFiltered(
              // Kontras ringan mempertegas tepi jalan dan label tanpa mengubah
              // warna overlay di atasnya.
              colorFilter: _tileColorFilter,
              child: TileLayer(
                urlTemplate: BasemapUrl.tileTemplate(AppConstants.basemapKey),
                subdomains: const ['a', 'b', 'c', 'd'],
                retinaMode: true,
                userAgentPackageName: 'com.kicaugo.mobile',
              ),
            ),
            if (hasRoute)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    color: AppColors.blueStrong,
                    strokeWidth: VenueMapPreview._routeStrokeWidth,
                    borderColor: AppColors.surface,
                    borderStrokeWidth: VenueMapPreview._routeBorderWidth,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (hasRoute)
                  Marker(
                    point: routePoints.first,
                    width: VenueMapPreview._originMarkerSize,
                    height: VenueMapPreview._originMarkerSize,
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
            // Atribusi wajib untuk tile CARTO/OSM; dibuat ringkas agar tidak
            // mendominasi preview kartu yang tingginya hanya 160 px.
            RichAttributionWidget(
              alignment: AttributionAlignment.bottomRight,
              showFlutterMapAttribution: false,
              popupBackgroundColor: AppColors.surface,
              permanentHeight: _attributionIconSize,
              attributions: const [
                TextSourceAttribution('OpenStreetMap contributors'),
                TextSourceAttribution('CARTO'),
              ],
              openButton: (context, open) => _attributionButton(
                icon: Icons.info_outline,
                tooltip: 'Atribusi peta',
                onPressed: open,
              ),
              closeButton: (context, close) => _attributionButton(
                icon: Icons.close,
                tooltip: 'Tutup atribusi',
                onPressed: close,
              ),
            ),
          ],
        ),
      ),
    );

    final onTap = options.onTap;
    if (onTap == null) {
      return map;
    }

    // FlutterMap memiliki gesture recognizer sendiri, jadi lapisan transparan
    // di atasnya yang menangkap tap untuk membuka halaman penuh.
    return Stack(
      children: [
        map,
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

/// Pin venue dengan label melayang dan riak lembut seperti desain.
///
/// Riak sengaja statis: animasi berulang membuat `pumpAndSettle` di test
/// tidak pernah selesai dan tidak memberi informasi bagi pengguna.
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
