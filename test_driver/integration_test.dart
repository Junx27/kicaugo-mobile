import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Driver `flutter drive` untuk menyimpan screenshot hasil integration test.
Future<void> main() async {
  await integrationDriver(
    onScreenshot:
        (
          String screenshotName,
          List<int> screenshotBytes, [
          Map<String, Object?>? args,
        ]) async {
          final file = File('build/screenshots/$screenshotName.png');
          await file.create(recursive: true);
          await file.writeAsBytes(screenshotBytes);
          return true;
        },
  );
}
