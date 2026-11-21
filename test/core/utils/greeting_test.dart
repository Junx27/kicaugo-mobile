import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/utils/greeting.dart';

DateTime _at(int hour) => DateTime(2026, 11, 20, hour);

void main() {
  test('sapaan mengikuti jam', () {
    expect(greetingFor(_at(4)), 'Selamat Pagi');
    expect(greetingFor(_at(10)), 'Selamat Pagi');
    expect(greetingFor(_at(11)), 'Selamat Siang');
    expect(greetingFor(_at(15)), 'Selamat Sore');
    expect(greetingFor(_at(18)), 'Selamat Malam');
    expect(greetingFor(_at(2)), 'Selamat Malam');
  });
}
