import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

/// Data yang dibutuhkan halaman peta penuh untuk sebuah venue.
class VenueMapArgs {
  const VenueMapArgs({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String title;
  final String address;
}

/// Membuka halaman peta penuh untuk sebuah venue dari kartu mana pun.
Future<void> pushVenueMap(BuildContext context, VenueMapArgs args) =>
    context.push(AppRoutes.venueMap, extra: args);
