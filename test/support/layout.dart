import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Memastikan lapisan pertama di bawah halaman tab adalah [SafeArea],
/// bukan pembungkus latar seperti [ColoredBox].
///
/// Tab yang mengikuti latar [MainShell] tidak boleh mengecat latarnya sendiri;
/// warna putih sudah berasal dari Scaffold shell.
void expectShellBackground(WidgetTester tester, Finder page) {
  final firstLayer = find
      .descendant(
        of: page,
        matching: find.byWidgetPredicate(
          (widget) => widget is ColoredBox || widget is SafeArea,
        ),
      )
      .first;
  expect(tester.widget(firstLayer), isA<SafeArea>());
}
