import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Menampilkan pesan singkat di bawah layar, mengganti pesan sebelumnya.
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}

/// Penanda fitur yang belum tersedia.
void showComingSoon(BuildContext context) {
  showAppSnackBar(context, AppConstants.comingSoon);
}
