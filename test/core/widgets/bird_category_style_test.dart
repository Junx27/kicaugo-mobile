import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/core/widgets/bird_category_style.dart';

void main() {
  test('label, ikon, dan warna tersedia untuk semua kategori', () {
    for (final category in BirdCategory.values) {
      expect(category.label, isNotEmpty);
      expect(category.icon, isNotNull);
      expect(category.iconColor, isNotNull);
    }
  });
}
