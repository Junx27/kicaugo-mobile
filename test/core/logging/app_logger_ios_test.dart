import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/logging/app_logger.dart';

void main() {
  test('warna otomatis nonaktif di iOS', () {
    final previous = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = previous);

    expect(AppLogger.colorEnabled, isFalse);
  });
}
