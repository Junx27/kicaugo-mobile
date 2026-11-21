import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/auth_strings.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/pages/register_page.dart';

import '../../../../support/fakes.dart';
import '../../../../support/pump_app.dart';

Future<void> _pumpLogin(WidgetTester tester, {FakeAuthRepository? repository}) {
  return pumpAuthPage(
    tester,
    initialLocation: AppRoutes.login,
    repository: repository,
  );
}

Checkbox _checkbox(WidgetTester tester) =>
    tester.widget<Checkbox>(find.byType(Checkbox));

void main() {
  testWidgets('menampilkan seluruh bagian halaman masuk', (tester) async {
    await _pumpLogin(tester);

    expect(find.text(AuthStrings.loginTitle), findsOneWidget);
    expect(find.text(AuthStrings.loginEyebrow), findsOneWidget);
    expect(find.text(AuthStrings.chipActiveContests), findsOneWidget);
    expect(find.text(AuthStrings.loginSubmit), findsOneWidget);
    expect(find.text(AuthStrings.loginGoogle), findsOneWidget);
    expect(find.text(AuthStrings.trustTitle), findsOneWidget);
    expect(find.text(AuthStrings.toRegister), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('kirim kosong menampilkan pesan wajib', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpLogin(tester, repository: repository);

    await tapVisible(tester, find.byKey(const Key('login_submit')));

    expect(find.text(AuthStrings.identifierRequired), findsOneWidget);
    expect(find.text(AuthStrings.passwordRequired), findsOneWidget);
    expect(repository.loginCalls, 0);
  });

  testWidgets('identifier tidak valid ditolak sebelum dikirim', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpLogin(tester, repository: repository);

    await submitLogin(tester, identifier: 'budi');

    expect(find.text(AuthStrings.identifierInvalid), findsOneWidget);
    expect(repository.loginCalls, 0);
  });

  testWidgets('kredensial valid masuk dengan nomor WhatsApp', (tester) async {
    final repository = FakeAuthRepository();
    await _pumpLogin(tester, repository: repository);

    await submitLogin(tester, identifier: '0812 3456 7890');

    expect(repository.loginCalls, 1);
  });

  testWidgets('tombol menampilkan loading selama proses masuk', (tester) async {
    await _pumpLogin(
      tester,
      repository: FakeAuthRepository(delay: const Duration(seconds: 5)),
    );

    await submitLogin(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('kegagalan masuk tampil sebagai SnackBar', (tester) async {
    await _pumpLogin(
      tester,
      repository: FakeAuthRepository(failuresRemaining: 1),
    );

    await submitLogin(tester);

    expect(find.text(AppConstants.loginFailure), findsOneWidget);
  });

  testWidgets('Ingat Saya bisa dicentang', (tester) async {
    await _pumpLogin(tester);
    expect(_checkbox(tester).value, isFalse);

    await tapVisible(tester, find.text(AuthStrings.rememberMe));

    expect(_checkbox(tester).value, isTrue);
  });

  for (final label in [
    AuthStrings.help,
    AuthStrings.forgotPassword,
    AuthStrings.loginGoogle,
  ]) {
    testWidgets('"$label" menampilkan segera hadir', (tester) async {
      await _pumpLogin(tester);

      await tapVisible(tester, find.text(label));

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  }

  testWidgets('tautan daftar membuka halaman register', (tester) async {
    await _pumpLogin(tester);

    await tapVisible(tester, find.text(AuthStrings.toRegister));

    expect(find.byType(RegisterPage), findsOneWidget);
  });
}
