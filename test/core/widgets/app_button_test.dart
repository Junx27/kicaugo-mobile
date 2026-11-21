import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/app_button.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  testWidgets('varian primary memanggil aksi saat ditekan', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      wrap(AppButton(label: 'SIMPAN', onPressed: () => tapped++)),
    );

    expect(find.text('SIMPAN'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    expect(tapped, 1);
  });

  testWidgets('menampilkan ikon trailing di kanan label', (tester) async {
    await tester.pumpWidget(
      wrap(
        AppButton(
          label: 'LANJUT',
          trailingIcon: Icons.arrow_forward,
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('LANJUT'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    expect(
      tester.getCenter(find.byIcon(Icons.arrow_forward)).dx,
      greaterThan(tester.getCenter(find.text('LANJUT')).dx),
    );
  });

  testWidgets('varian primary menampilkan spinner onPrimary', (tester) async {
    await tester.pumpWidget(
      wrap(AppButton(label: 'MASUK', isLoading: true, onPressed: () {})),
    );

    final spinner = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(spinner.color, AppTheme.light.colorScheme.onPrimary);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('varian outlined memakai spinner primary dan nonaktif', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        AppButton(
          label: 'GOOGLE',
          variant: AppButtonVariant.outlined,
          isLoading: true,
          onPressed: () {},
        ),
      ),
    );

    final spinner = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(spinner.color, AppTheme.light.colorScheme.primary);
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );
  });
}
