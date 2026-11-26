import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/widgets/color_pill.dart';

Future<Size> _pumpPill(WidgetTester tester, ColorPill pill) async {
  await tester.pumpWidget(Center(child: pill));
  return tester.getSize(find.byType(ColorPill));
}

void main() {
  testWidgets('pill memakai lebar, tinggi, dan warna yang diberikan', (
    tester,
  ) async {
    final size = await _pumpPill(
      tester,
      const ColorPill(width: 32, height: 8, color: AppColors.primary),
    );

    expect(size, const Size(32, 8));
    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    expect((box.decoration as BoxDecoration).color, AppColors.primary);
  });

  testWidgets('dot berbentuk persegi dengan sisi sama', (tester) async {
    final size = await _pumpPill(
      tester,
      const ColorPill.dot(size: 6, color: AppColors.pink),
    );

    expect(size, const Size(6, 6));
  });

  testWidgets('konstruktor utama dapat dipakai tanpa const', (tester) async {
    const createPill = ColorPill.new;
    final size = await _pumpPill(
      tester,
      createPill(width: 4, height: 2, color: AppColors.lime),
    );

    expect(size, const Size(4, 2));
  });
}
