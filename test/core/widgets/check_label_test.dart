import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/check_label.dart';

Future<List<bool>> _pump(
  WidgetTester tester, {
  required bool value,
  String? errorText,
}) async {
  final changes = <bool>[];
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: CheckLabel(
          value: value,
          label: 'Setuju',
          errorText: errorText,
          onChanged: changes.add,
        ),
      ),
    ),
  );
  return changes;
}

void main() {
  testWidgets('mengetuk label membalik nilai', (tester) async {
    final changes = await _pump(tester, value: false);

    await tester.tap(find.text('Setuju'));

    expect(changes, [true]);
  });

  testWidgets('mengetuk kotak centang membalik nilai', (tester) async {
    final changes = await _pump(tester, value: true);

    await tester.tap(find.byType(Checkbox));

    expect(changes, [false]);
  });

  testWidgets('menampilkan pesan galat bila ada', (tester) async {
    await _pump(tester, value: false, errorText: 'Wajib dicentang');

    expect(find.text('Wajib dicentang'), findsOneWidget);
  });
}
