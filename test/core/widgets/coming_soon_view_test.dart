import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/coming_soon_view.dart';

Future<void> _pumpView(WidgetTester tester, {Widget? footer}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: ComingSoonView(
          title: 'Judul',
          icon: Icons.star_outline,
          footer: footer,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('menampilkan judul, ikon, dan teks segera hadir', (tester) async {
    await _pumpView(tester);

    expect(find.text('Judul'), findsOneWidget);
    expect(find.byIcon(Icons.star_outline), findsOneWidget);
    expect(find.text(AppConstants.comingSoon), findsOneWidget);
  });

  testWidgets('menampilkan footer bila diberikan', (tester) async {
    await _pumpView(tester, footer: const Text('Footer'));

    expect(find.text('Footer'), findsOneWidget);
  });
}
