import 'package:flutter/material.dart';

import '../logging/app_logger.dart';

const String _tag = 'NAV';

/// Mencatat halaman yang dibuka dan ditutup oleh navigator.
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.log(
      _tag,
      'PUSH ${_describe(route)} from ${_describe(previousRoute)}',
      icon: '🚀',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.log(
      _tag,
      'POP ${_describe(route)} to ${_describe(previousRoute)}',
      icon: '🔙',
    );
  }

  /// Memakai nama rute, lalu tipe route bila nama tidak tersedia.
  String _describe(Route<dynamic>? route) =>
      route?.settings.name ?? route?.runtimeType.toString() ?? 'unknown';
}
