import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/widgets/color_pill.dart';
import 'package:rumahkicau_mobile/core/widgets/pulse_badge.dart';

Future<void> _pumpBadge(WidgetTester tester, PulseBadge badge) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: badge)));
}

Finder _insideBadge(Finder finder) =>
    find.descendant(of: find.byType(PulseBadge), matching: finder);

void main() {
  testWidgets('ukuran dan warna default mengikuti chip kategori', (
    tester,
  ) async {
    await _pumpBadge(tester, const PulseBadge(label: 'LIVE'));

    final boxes = tester
        .widgetList<DecoratedBox>(_insideBadge(find.byType(DecoratedBox)))
        .toList();
    expect(
      (boxes.first.decoration as BoxDecoration).color,
      AppColors.lavenderGlow,
    );

    final sized = tester
        .widgetList<SizedBox>(_insideBadge(find.byType(SizedBox)))
        .toList();
    expect(sized.any((box) => box.height == 32), isTrue);

    final padding = tester
        .widgetList<Padding>(_insideBadge(find.byType(Padding)))
        .first;
    expect(padding.padding, const EdgeInsets.symmetric(horizontal: 12));

    final label = tester.widget<Text>(find.text('LIVE'));
    expect(label.style?.color, AppColors.onPink);
    expect(find.byType(ColorPill), findsOneWidget);
  });

  testWidgets('ikon menggantikan titik berdenyut', (tester) async {
    await _pumpBadge(
      tester,
      const PulseBadge(label: 'LIVE', icon: Icons.sensors_rounded),
    );

    expect(find.byType(ColorPill), findsNothing);
    expect(find.byIcon(Icons.sensors_rounded), findsOneWidget);
  });
}
