import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/utils/basemap_url.dart';

void main() {
  const fakeKey = 'test-key';

  test('memakai template tile CARTO Voyager', () {
    expect(
      BasemapUrl.tileTemplate(fakeKey),
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/'
      '{z}/{x}/{y}{r}.png?key=$fakeKey',
    );
  });

  test('template memakai subdomain, retina, dan API key', () {
    final url = BasemapUrl.tileTemplate(fakeKey);

    expect(url, contains('{s}'));
    expect(url, contains('{r}'));
    expect(url, contains('key=$fakeKey'));
    expect(url, isNot(contains('tile.openstreetmap.org')));
  });
}
