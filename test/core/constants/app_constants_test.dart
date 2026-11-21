import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/constants/app_flavor.dart';

void main() {
  group('konfigurasi flavor di AppConstants', () {
    test('flavor aktif mengikuti environment', () {
      expect(AppConstants.flavor, AppFlavor.fromName(flavorName));
    });

    test('apiBaseUrl memakai override atau default sesuai flavor', () {
      const String overridden = String.fromEnvironment('API_BASE_URL');
      final String expected = overridden.isEmpty
          ? AppFlavor.fromName(flavorName).defaultApiBaseUrl
          : overridden;
      expect(AppConstants.apiBaseUrl, expected);
    });

    test('useApi memakai override atau default sesuai flavor', () {
      const bool hasOverride = bool.hasEnvironment('USE_API');
      final bool expected = hasOverride
          ? const bool.fromEnvironment('USE_API')
          : AppFlavor.fromName(flavorName).defaultUseApi;
      expect(AppConstants.useApi, expected);
    });
  });
}
