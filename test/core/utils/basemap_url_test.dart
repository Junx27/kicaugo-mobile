import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/utils/basemap_url.dart';

void main() {
  test('memakai template tile backend', () {
    expect(
      BasemapUrl.tileTemplate(AppConstants.apiBaseUrl),
      '${AppConstants.apiBaseUrl}/api/v1/basemap/tiles/{z}/{x}/{y}',
    );
  });

  test('template memakai placeholder z/x/y tanpa key', () {
    final url = BasemapUrl.tileTemplate(AppConstants.apiBaseUrl);

    expect(url, contains('{z}'));
    expect(url, contains('{x}'));
    expect(url, contains('{y}'));
    expect(url, isNot(contains('cartocdn')));
    expect(url, isNot(contains('key=')));
  });
}
