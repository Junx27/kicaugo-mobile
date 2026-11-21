import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/help_center_strings.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/widgets/help_pill_button.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/widgets/help_quick_actions.dart';

import '../../help_center_fakes.dart';

void main() {
  testWidgets('pill button tanpa ikon tetap bisa ditekan', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: HelpPillButton(label: 'Aksi', onPressed: () => taps++),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_forward_rounded), findsNothing);

    await tester.tap(find.text('Aksi'));

    expect(taps, 1);
  });

  testWidgets('pill button dengan ikon menampilkan ikon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: HelpPillButton(
            label: 'Aksi',
            icon: Icons.call_rounded,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.call_rounded), findsOneWidget);
  });

  testWidgets('quick actions berjumlah ganjil tetap tersusun', (tester) async {
    final actions = sampleHelpCenter.quickActions.take(3).toList();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HelpQuickActions(actions: actions),
          ),
        ),
      ),
    );

    expect(find.text(HelpCenterStrings.quickTitle), findsOneWidget);
    expect(find.text(HelpCenterStrings.quickCount(3)), findsOneWidget);
    for (final action in actions) {
      expect(find.text(action.title), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}
