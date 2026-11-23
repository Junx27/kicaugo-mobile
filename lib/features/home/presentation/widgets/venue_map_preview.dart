import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Preview peta in-app untuk lokasi venue lomba.
///
/// Widget ini hanya menampilkan peta dan marker; navigasi turn-by-turn tetap
/// dilakukan lewat aplikasi peta native agar tetap gratis tanpa API routing.
class VenueMapPreview extends StatelessWidget {
  const VenueMapPreview({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 160,
    this.interactive = false,
    this.onTap,
  });

  final double latitude;
  final double longitude;
  final double height;
  final bool interactive;

  /// Aksi saat preview diketuk; `null` membiarkan peta menangani gestur sendiri.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final center = LatLng(latitude, longitude);
    final map = ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 14,
            interactionOptions: InteractionOptions(
              flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.kicaugo.mobile',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 36,
                  height: 36,
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.onPink,
                    size: 36,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

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
