import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/utils/navigation_url_builder.dart';

void main() {
  test('membuat URL dengan origin dan destination koordinat', () {
    final url = buildExternalNavigationUrl(
      originLatitude: -6.1,
      originLongitude: 106.7,
      destinationLatitude: -6.2,
      destinationLongitude: 106.8,
    );

    expect(url, contains('www.google.com/maps/dir/'));
    expect(url, contains('origin=-6.1%2C106.7'));
    expect(url, contains('destination=-6.2%2C106.8'));
  });

  test('membuat URL tanpa origin bila lokasi user tidak tersedia', () {
    final url = buildExternalNavigationUrl(
      destinationLatitude: -6.2,
      destinationLongitude: 106.8,
    );

    expect(url, contains('destination=-6.2%2C106.8'));
    expect(url, isNot(contains('origin=')));
  });

  test('fallback ke query teks bila koordinat tujuan tidak tersedia', () {
    final url = buildExternalNavigationUrl(destinationQuery: 'Batavia Arena');

    expect(url, contains('www.google.com/maps/search/'));
    expect(url, contains('query=Batavia+Arena'));
  });

  test('mengembalikan null bila tidak ada koordinat dan query', () {
    final url = buildExternalNavigationUrl();
    expect(url, isNull);
  });
}
