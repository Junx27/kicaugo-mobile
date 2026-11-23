import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/router/venue_map_args.dart';
import '../../../../core/routing/route_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/external_navigation.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/status_dot.dart';
import '../home_strings.dart';
import '../widgets/venue_map_preview.dart';

/// Halaman peta penuh in-app untuk lokasi venue lomba.
///
/// Kanvas memakai peta OSM nyata, sedang overlay mengambang mengikuti desain:
/// bar atas, kontrol zoom kanan, dan sheet detail di bawah. Tombol rute
/// menggambar garis dari lokasi pengguna ke venue langsung di peta; navigasi
/// turn-by-turn tetap memakai aplikasi peta native.
class VenueMapPage extends StatelessWidget {
  const VenueMapPage({
    super.key,
    required this.args,
    required this.routeService,
    required this.locationService,
  });

  /// Boleh null bila halaman dibuka langsung tanpa argumen.
  final VenueMapArgs? args;

  final RouteService routeService;
  final LocationService locationService;

  @override
  Widget build(BuildContext context) {
    final venue = args;
    if (venue == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(HomeStrings.venueMapTitle)),
        body: const Center(child: Text(HomeStrings.venueNotFound)),
      );
    }
    return Scaffold(
      body: _VenueMapScreen(
        venue: venue,
        routeService: routeService,
        locationService: locationService,
      ),
    );
  }
}

class _VenueMapScreen extends StatefulWidget {
  const _VenueMapScreen({
    required this.venue,
    required this.routeService,
    required this.locationService,
  });

  final VenueMapArgs venue;
  final RouteService routeService;
  final LocationService locationService;

  @override
  State<_VenueMapScreen> createState() => _VenueMapScreenState();
}

class _VenueMapScreenState extends State<_VenueMapScreen> {
  final MapController _controller = MapController();
  bool _mapReady = false;

  /// Sheet dan label pin saling menutupi: saat detail terlihat label disembunyikan.
  bool _sheetVisible = true;

  /// Rute in-app dari lokasi pengguna ke venue; null sebelum dihitung.
  RoutePath? _route;
  bool _routeLoading = false;

  static const Duration _sheetAnimationDuration = Duration(milliseconds: 240);
  static const EdgeInsets _routeFitPadding = EdgeInsets.fromLTRB(
    48,
    96,
    64,
    48,
  );
  static const double _metersPerKm = 1000;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleReady() => setState(() => _mapReady = true);

  void _hideSheet() => setState(() => _sheetVisible = false);

  void _showSheet() => setState(() => _sheetVisible = true);

  void _zoom(double delta) {
    if (!_mapReady) return;
    final camera = _controller.camera;
    _controller.move(camera.center, camera.zoom + delta);
  }

  void _resetView() {
    if (!_mapReady) return;
    _controller.move(
      LatLng(widget.venue.latitude, widget.venue.longitude),
      VenueMapPreview.defaultZoom,
    );
  }

  void _locateVenue() {
    _resetView();
    showAppSnackBar(context, HomeStrings.venueLocated);
  }

  /// Menggambar rute dari lokasi terkini ke venue langsung di peta, tanpa
  /// membuka aplikasi eksternal. Sheet ditutup agar garis terlihat penuh.
  Future<void> _openRoute() async {
    if (_routeLoading) return;
    setState(() => _routeLoading = true);
    final origin = await _readOrigin();
    final route = origin == null ? null : await _fetchRoute(origin);
    if (!mounted) return;
    setState(() {
      // Kegagalan tidak menghapus garis lama yang sudah tampil.
      _route = route ?? _route;
      _routeLoading = false;
      if (route != null) _sheetVisible = false;
    });
    if (origin == null) {
      showAppSnackBar(context, HomeStrings.routeOriginUnavailable);
    } else if (route == null) {
      showAppSnackBar(context, HomeStrings.routeUnavailable);
    } else {
      _fitRoute(route);
      showAppSnackBar(context, _routeMessage(route));
    }
  }

  Future<DeviceLocation?> _readOrigin() async {
    try {
      return await widget.locationService.readCurrentLocation();
    } catch (_) {
      return null;
    }
  }

  Future<RoutePath?> _fetchRoute(DeviceLocation origin) async {
    try {
      final venue = widget.venue;
      return await widget.routeService.fetchRoute(
        originLatitude: origin.latitude,
        originLongitude: origin.longitude,
        destinationLatitude: venue.latitude,
        destinationLongitude: venue.longitude,
      );
    } catch (_) {
      return null;
    }
  }

  void _fitRoute(RoutePath route) {
    if (!_mapReady) return;
    _controller.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(route.points),
        padding: _routeFitPadding,
      ),
    );
  }

  String _routeMessage(RoutePath route) {
    final meters = route.distanceM;
    if (meters == null) return HomeStrings.routeShown;
    final km = (meters / _metersPerKm).toStringAsFixed(1);
    return '${HomeStrings.routeShown} • $km km';
  }

  void _back() => Navigator.maybePop(context);

  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;
    return Stack(
      fit: StackFit.expand,
      children: [
        VenueMapPreview(
          latitude: venue.latitude,
          longitude: venue.longitude,
          route: _route,
          options: VenueMapOptions(
            height: double.infinity,
            interactive: true,
            borderRadius: BorderRadius.zero,
            controller: _controller,
            markerLabel: venue.title,
            showMarkerLabel: !_sheetVisible,
            onMarkerTap: _showSheet,
            onReady: _handleReady,
          ),
        ),
        _TopBar(onBack: _back, onReset: _resetView),
        _MapControls(
          onZoomIn: () => _zoom(1),
          onZoomOut: () => _zoom(-1),
          onLocate: _locateVenue,
          onRoute: _routeLoading ? null : _openRoute,
          routeLoading: _routeLoading,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSlide(
            offset: Offset(0, _sheetVisible ? 0 : 1.5),
            duration: _sheetAnimationDuration,
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: !_sheetVisible,
              child: _VenueSheet(venue: venue, onDismiss: _hideSheet),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bar atas mengambang: tombol kembali, kapsul judul, dan tombol orientasi.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.onReset});

  final VoidCallback onBack;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _RoundButton(
                icon: Icons.arrow_back_ios_new_rounded,
                tooltip: HomeStrings.backTooltip,
                onPressed: onBack,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Text(
                      HomeStrings.venueMapTitle,
                      style: AppTextStyles.title.copyWith(fontSize: 15),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              _RoundButton(
                icon: Icons.explore_rounded,
                tooltip: HomeStrings.compassTooltip,
                onPressed: onReset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tombol bundar transparan dengan latar putih seperti kontrol peta.
class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Icon(icon, size: AppTheme.iconSize, color: AppColors.textPrimary),
        tooltip: tooltip,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        onPressed: onPressed,
      ),
    );
  }
}

/// Kontrol kanan: zoom masuk/keluar, kembali ke titik venue, dan rute in-app.
class _MapControls extends StatelessWidget {
  const _MapControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLocate,
    required this.onRoute,
    required this.routeLoading,
  });

  static const double _loadingStrokeWidth = 2;

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLocate;
  final VoidCallback? onRoute;
  final bool routeLoading;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Material(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_rounded),
                    tooltip: HomeStrings.zoomInTooltip,
                    onPressed: onZoomIn,
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  IconButton(
                    icon: const Icon(Icons.remove_rounded),
                    tooltip: HomeStrings.zoomOutTooltip,
                    onPressed: onZoomOut,
                  ),
                ],
              ),
            ),
            Material(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                icon: const Icon(Icons.my_location_rounded),
                tooltip: HomeStrings.locateTooltip,
                onPressed: onLocate,
              ),
            ),
            Material(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                icon: routeLoading
                    ? const SizedBox(
                        width: AppTheme.smallIconSize,
                        height: AppTheme.smallIconSize,
                        child: CircularProgressIndicator(
                          strokeWidth: _loadingStrokeWidth,
                        ),
                      )
                    : const Icon(Icons.directions_rounded),
                tooltip: HomeStrings.routeTooltip,
                onPressed: onRoute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet detail venue dengan aksi navigasi, salin alamat, dan info parkir.
///
/// Geser ke bawah atau ketuk handle untuk menutup seluruh kartu. Penutupan
/// dikelola induk karena label pin harus muncul saat kartu tidak terlihat.
class _VenueSheet extends StatelessWidget {
  const _VenueSheet({required this.venue, required this.onDismiss});

  final VenueMapArgs venue;
  final VoidCallback onDismiss;

  static const List<BoxShadow> _sheetShadow = <BoxShadow>[
    BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, -6)),
  ];

  void _handleDragEnd(DragEndDetails details) {
    if ((details.primaryVelocity ?? 0) > 0) onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    // SafeArea akan menyisahkan area transparan di bawah kartu sehingga peta
    // masih terlihat. Inset bawah dimasukkan ke padding kartu agar latar kartu
    // tetap menutup sampai tepi layar.
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: _handleDragEnd,
      child: Container(
        key: const Key('venue_detail_sheet'),
        padding: EdgeInsets.fromLTRB(20, 6, 20, 16 + bottomInset),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.sheetRadius),
          ),
          boxShadow: _sheetShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              key: const Key('venue_sheet_handle'),
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: _DragHandle(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              venue.title,
              style: AppTextStyles.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            _MetaRow(schedule: venue.schedule, address: venue.address),
            const SizedBox(height: 10),
            _DistancePill(distance: venue.distance),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => openExternalNavigation(
                context: context,
                destinationLatitude: venue.latitude,
                destinationLongitude: venue.longitude,
                destinationQuery: venue.address,
              ),
              icon: const Icon(Icons.navigation_rounded, size: 18),
              label: const Text(HomeStrings.openNavigation),
            ),
            const SizedBox(height: 10),
            _SheetActions(address: venue.address),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        ),
      ),
    );
  }
}

/// Baris meta tanggal dan alamat; alamat yang sama dengan jadwal tidak diulang.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.schedule, required this.address});

  final String schedule;
  final String address;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (schedule.isNotEmpty) schedule,
      if (address.isNotEmpty && address != schedule) address,
    ];
    if (parts.isEmpty) return const SizedBox.shrink();
    return Text(
      parts.join('  •  '),
      style: AppTextStyles.caption,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Pill jarak dengan titik hijau; disembunyikan bila backend belum mengirim.
class _DistancePill extends StatelessWidget {
  const _DistancePill({required this.distance});

  final String distance;

  @override
  Widget build(BuildContext context) {
    if (distance.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const StatusDot(color: AppColors.limeStrong),
          Text(distance, style: AppTextStyles.label),
        ],
      ),
    );
  }
}

class _SheetActions extends StatelessWidget {
  const _SheetActions({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: _SecondaryAction(
            icon: Icons.copy_all_rounded,
            label: HomeStrings.copyAddress,
            onPressed: () => _copyAddress(context, address),
          ),
        ),
        Expanded(
          child: _SecondaryAction(
            icon: Icons.local_parking_rounded,
            label: HomeStrings.paddockParking,
            onPressed: () => showAppSnackBar(context, HomeStrings.parkingInfo),
          ),
        ),
      ],
    );
  }
}

void _copyAddress(BuildContext context, String address) {
  unawaited(Clipboard.setData(ClipboardData(text: address)));
  showAppSnackBar(context, HomeStrings.addressCopied);
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppTheme.smallIconSize),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: const BorderSide(color: AppColors.border),
        textStyle: AppTextStyles.label,
      ),
    );
  }
}
