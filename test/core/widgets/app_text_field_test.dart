import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/core/widgets/app_text_field.dart';

const _spec = AppFieldSpec(
  label: 'Kata Sandi',
  labelTrailing: 'Minimal 8',
  hint: 'Isi sandi',
  icon: Icons.lock,
);

Future<GlobalKey<FormState>> _pump(
  WidgetTester tester, {
  AppFieldSpec spec = _spec,
  bool obscureText = false,
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Form(
          key: formKey,
          child: AppTextField(
            controller: controller,
            spec: spec,
            obscureText: obscureText,
            validator: (value) => (value ?? '').isEmpty ? 'Wajib' : null,
          ),
        ),
      ),
    ),
  );
  return formKey;
}

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

void main() {
  testWidgets('label di atas field, contoh di kanan, ikon dan placeholder', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Kata Sandi'), findsOneWidget);
    expect(find.text('Minimal 8'), findsOneWidget);
    expect(find.text('Isi sandi'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('tanpa labelTrailing hanya label yang tampil', (tester) async {
    await _pump(
      tester,
      spec: const AppFieldSpec(label: 'Nama', icon: Icons.person),
    );

    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Minimal 8'), findsNothing);
  });

  testWidgets('toggle sandi menampilkan lalu menyembunyikan teks', (
    tester,
  ) async {
    await _pump(tester, obscureText: true);
    expect(_editable(tester).obscureText, isTrue);

    await tester.tap(find.byTooltip(AppTextField.showPasswordTooltip));
    await tester.pump();
    expect(_editable(tester).obscureText, isFalse);

    await tester.tap(find.byTooltip(AppTextField.hidePasswordTooltip));
    await tester.pump();
    expect(_editable(tester).obscureText, isTrue);
  });

  testWidgets('pesan validator tampil di bawah field', (tester) async {
    final formKey = await _pump(tester);

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Wajib'), findsOneWidget);
  });
}
