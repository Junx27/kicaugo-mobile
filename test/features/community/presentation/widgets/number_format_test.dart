import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/community/presentation/widgets/number_format.dart';

void main() {
  test('memberi pemisah ribuan titik', () {
    expect(formatThousands(7), '7');
    expect(formatThousands(890), '890');
    expect(formatThousands(4200), '4.200');
    expect(formatThousands(1234567), '1.234.567');
  });
}
