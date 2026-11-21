import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/widgets/initials_avatar.dart';

BoxDecoration _decoration(WidgetTester tester) =>
    tester.widget<Container>(find.byType(Container)).decoration!
        as BoxDecoration;

Future<void> _pump(WidgetTester tester, InitialsAvatar avatar) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: avatar)),
    ),
  );
}

void main() {
  testWidgets('default berbentuk lingkaran berisi inisial', (tester) async {
    await _pump(tester, const InitialsAvatar(initials: 'BS'));

    expect(find.text('BS'), findsOneWidget);
    expect(_decoration(tester).shape, BoxShape.circle);
    expect(tester.getSize(find.byType(InitialsAvatar)), const Size(44, 44));
  });

  testWidgets('radius membuat kotak bersudut', (tester) async {
    await _pump(
      tester,
      const InitialsAvatar(initials: 'PB', size: 40, radius: 16),
    );

    expect(_decoration(tester).shape, BoxShape.rectangle);
    expect(_decoration(tester).borderRadius, BorderRadius.circular(16));
  });
}
