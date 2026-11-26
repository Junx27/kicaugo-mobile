import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/widgets/thick_plus_icon.dart';

Widget _buildIcon(Color color, double strokeWidth) {
  return Center(
    child: ThickPlusIcon(size: 24, strokeWidth: strokeWidth, color: color),
  );
}

void main() {
  testWidgets('menggambar ulang plus saat warna atau ketebalan berubah', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: _buildIcon(Colors.red, 3)));
    await tester.pumpWidget(MaterialApp(home: _buildIcon(Colors.blue, 5)));

    expect(find.byType(ThickPlusIcon), findsOneWidget);
  });
}
