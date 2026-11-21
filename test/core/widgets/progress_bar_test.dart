import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/widgets/progress_bar.dart';

void main() {
  testWidgets('nilai dipotong ke rentang 0–1', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ProgressBar(value: 0.8),
              ProgressBar(value: 1.4, height: 6),
            ],
          ),
        ),
      ),
    );

    final values = tester
        .widgetList<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        )
        .map((indicator) => indicator.value)
        .toList();
    expect(values, [0.8, 1.0]);
  });
}
