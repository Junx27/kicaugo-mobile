import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_flavor.dart';

void main() {
  group('AppFlavor.fromName', () {
    test('memetakan dev', () {
      expect(AppFlavor.fromName(devFlavorName), AppFlavor.dev);
    });

    test('memetakan stg', () {
      expect(AppFlavor.fromName(stgFlavorName), AppFlavor.stg);
    });

    test('memetakan production', () {
      expect(AppFlavor.fromName(productionFlavorName), AppFlavor.production);
    });

    test('jatuh ke dev untuk nama kosong atau tidak dikenal', () {
      expect(AppFlavor.fromName(null), AppFlavor.dev);
      expect(AppFlavor.fromName(''), AppFlavor.dev);
      expect(AppFlavor.fromName('qa'), AppFlavor.dev);
    });
  });

  group('nilai bawaan flavor', () {
    test('dev memakai URL lokal dan fake data', () {
      expect(AppFlavor.dev.defaultApiBaseUrl, devApiBaseUrl);
      expect(AppFlavor.dev.defaultUseApi, isFalse);
    });

    test('stg memakai API', () {
      expect(AppFlavor.stg.defaultApiBaseUrl, stgApiBaseUrl);
      expect(AppFlavor.stg.defaultUseApi, isTrue);
    });

    test('production memakai API', () {
      expect(AppFlavor.production.defaultApiBaseUrl, productionApiBaseUrl);
      expect(AppFlavor.production.defaultUseApi, isTrue);
    });

    test('flavor aktif konsisten dengan flavorName', () {
      expect(currentFlavor, AppFlavor.fromName(flavorName));
    });
  });
}
