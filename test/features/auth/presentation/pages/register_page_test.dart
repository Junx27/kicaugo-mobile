import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/auth_strings.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/pages/login_page.dart';

import '../../../../support/fakes.dart';
import '../../../../support/pump_app.dart';

Future<AuthBloc> _pumpRegister(
  WidgetTester tester, {
  FakeAuthRepository? repository,
}) {
  return pumpAuthPage(
    tester,
    initialLocation: AppRoutes.register,
    repository: repository,
  );
}

Finder _field(String name) => find.byKey(Key('register_$name'));

/// Mengisi formulir daftar; kosongkan argumen untuk menguji validasi.
Future<void> _fillForm(
  WidgetTester tester, {
  String name = 'Sari Kicau',
  String identifier = '08123456789',
  String password = demoPassword,
  String? confirm,
  bool acceptTerms = true,
}) async {
  await enterField(tester, _field('name'), name);
  await enterField(tester, _field('identifier'), identifier);
  await enterField(tester, _field('password'), password);
  await enterField(tester, _field('confirm'), confirm ?? password);
  if (acceptTerms) {
    await tapVisible(tester, find.text(AuthStrings.acceptTerms));
  }
}

Future<void> _submit(WidgetTester tester) =>
    tapVisible(tester, _field('submit'));

void main() {
  testWidgets('menampilkan seluruh bagian halaman daftar', (tester) async {
    await _pumpRegister(tester);

    expect(find.text(AuthStrings.registerTitle), findsOneWidget);
    expect(find.text(AuthStrings.chipFreeSignUp), findsOneWidget);
    expect(find.text(AuthStrings.registerGoogle), findsOneWidget);
    expect(find.text(AuthStrings.toLogin), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('kirim kosong menampilkan semua pesan wajib', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpRegister(tester, repository: repository);

    await _submit(tester);

    expect(find.text(AuthStrings.nameRequired), findsOneWidget);
    expect(find.text(AuthStrings.identifierRequired), findsOneWidget);
    expect(find.text(AuthStrings.passwordRequired), findsOneWidget);
    expect(find.text(AuthStrings.confirmRequired), findsOneWidget);
    expect(find.text(AuthStrings.termsRequired), findsOneWidget);
    expect(repository.registerCalls, 0);
  });

  testWidgets('sandi pendek dan konfirmasi berbeda ditolak', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpRegister(tester, repository: repository);

    await _fillForm(tester, password: '1234567', confirm: '7654321');
    await _submit(tester);

    expect(find.text(AuthStrings.passwordTooShort), findsOneWidget);
    expect(find.text(AuthStrings.confirmMismatch), findsOneWidget);
    expect(repository.registerCalls, 0);
  });

  testWidgets('tanpa persetujuan S&K tidak dikirim', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpRegister(tester, repository: repository);

    await _fillForm(tester, acceptTerms: false);
    await _submit(tester);

    expect(find.text(AuthStrings.termsRequired), findsOneWidget);
    expect(repository.registerCalls, 0);
  });

  testWidgets('data valid membuat akun dan sesi', (tester) async {
    final repository = FakeAuthRepository();
    final authBloc = await _pumpRegister(tester, repository: repository);

    await _fillForm(tester);
    await _submit(tester);

    expect(repository.registerCalls, 1);
    expect(authBloc.state.isAuthenticated, isTrue);
    expect(authBloc.state.user?.name, 'Sari Kicau');
  });

  testWidgets('kegagalan daftar tampil sebagai SnackBar', (tester) async {
    await _pumpRegister(
      tester,
      repository: FakeAuthRepository(failuresRemaining: 1),
    );

    await _fillForm(tester);
    await _submit(tester);

    expect(find.text(AppConstants.registerFailure), findsOneWidget);
  });

  testWidgets('tautan masuk kembali ke halaman login', (tester) async {
    await _pumpRegister(tester);

    await tapVisible(tester, find.text(AuthStrings.toLogin));

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
