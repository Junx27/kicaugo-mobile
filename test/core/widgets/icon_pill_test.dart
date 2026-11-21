import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/widgets/icon_pill.dart';

Future<void> _pump(WidgetTester tester, IconPill pill) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: pill)),
    ),
  );
}

void main() {
  testWidgets('menampilkan ikon berwarna dan label', (tester) async {
    await _pump(
      tester,
      const IconPill(
        icon: Icons.star,
        iconColor: AppColors.onYellow,
        label: 'Bintang',
      ),
    );

    expect(find.text('Bintang'), findsOneWidget);
    expect(
      tester.widget<Icon>(find.byIcon(Icons.star)).color,
      AppColors.onYellow,
    );
  });

  testWidgets('tanpa ikon hanya menampilkan label', (tester) async {
    await _pump(tester, const IconPill(label: 'Kacer', backgroundAlpha: 0.9));

    expect(find.text('Kacer'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });
}
