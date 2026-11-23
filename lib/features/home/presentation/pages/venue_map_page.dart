import 'package:flutter/material.dart';

import '../../../../core/router/venue_map_args.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/external_navigation.dart';
import '../home_strings.dart';
import '../widgets/venue_map_preview.dart';

/// Halaman peta penuh in-app untuk lokasi venue lomba.
///
/// Navigasi turn-by-turn tetap memakai aplikasi peta native lewat tombol
/// "Buka navigasi", sehingga tidak memerlukan API routing berbayar.
class VenueMapPage extends StatelessWidget {
  const VenueMapPage({super.key, required this.args});

  /// Boleh null bila halaman dibuka langsung tanpa argumen.
  final VenueMapArgs? args;

  @override
  Widget build(BuildContext context) {
    final venue = args;
    return Scaffold(
      appBar: AppBar(title: const Text(HomeStrings.venueMapTitle)),
      body: venue == null
          ? const Center(child: Text(HomeStrings.venueNotFound))
          : _VenueMap(venue: venue),
    );
  }
}

class _VenueMap extends StatelessWidget {
  const _VenueMap({required this.venue});

  final VenueMapArgs venue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: VenueMapPreview(
            latitude: venue.latitude,
            longitude: venue.longitude,
            height: double.infinity,
            interactive: true,
          ),
        ),
        _VenueDetails(venue: venue),
      ],
    );
  }
}

class _VenueDetails extends StatelessWidget {
  const _VenueDetails({required this.venue});

  final VenueMapArgs venue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.pagePadding),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.cardRadius),
        ),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(venue.title, style: AppTextStyles.cardTitle),
          Text(venue.address, style: AppTextStyles.caption),
          FilledButton.icon(
            onPressed: () => openExternalNavigation(
              context: context,
              destinationLatitude: venue.latitude,
              destinationLongitude: venue.longitude,
              destinationQuery: venue.address,
            ),
            icon: const Icon(Icons.directions_rounded, size: 18),
            label: const Text(HomeStrings.openNavigation),
          ),
        ],
      ),
    );
  }
}
