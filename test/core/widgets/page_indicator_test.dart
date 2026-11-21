import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/widgets/page_indicator.dart';

void main() {
  testWidgets('indikator aktif memanjang, lainnya berupa titik', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: PageIndicator(count: 3, current: 1)),
      ),
    );

    final sizes = tester
        .elementList(find.byType(AnimatedContainer))
        .map((element) => element.size!)
        .toList();

    expect(sizes, const [Size(8, 8), Size(28, 8), Size(8, 8)]);
  });
}
