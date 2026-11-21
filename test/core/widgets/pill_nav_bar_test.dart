import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/pill_nav_bar.dart';

void main() {
  testWidgets('item aktif berwarna primary, badge tampil, ketukan dilaporkan', (
    tester,
  ) async {
    final taps = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: PillNavBar(
            currentIndex: 0,
            onSelected: taps.add,
            items: const [
              PillNavItem(icon: Icons.home, label: 'Satu'),
              PillNavItem(icon: Icons.star, label: 'Dua', badge: 2),
              PillNavItem(icon: Icons.person, label: 'Tiga', badge: 0),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.widget<Icon>(find.byIcon(Icons.home)).color,
      AppColors.primary,
    );
    expect(
      tester.widget<Icon>(find.byIcon(Icons.star)).color,
      AppColors.textSecondary,
    );
    expect(find.text('2'), findsOneWidget);
    expect(find.text('0'), findsNothing);

    await tester.tap(find.text('Dua'));
    expect(taps, [1]);
  });
}
