import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/auth_strings.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/auth_validators.dart';

void main() {
  test('identifier: wajib, format, lalu sah', () {
    expect(AuthValidators.identifier(null), AuthStrings.identifierRequired);
    expect(AuthValidators.identifier('  '), AuthStrings.identifierRequired);
    expect(AuthValidators.identifier('budi'), AuthStrings.identifierInvalid);
    expect(AuthValidators.identifier('08123456789'), isNull);
  });

  test('password login hanya wajib diisi', () {
    expect(AuthValidators.password(null), AuthStrings.passwordRequired);
    expect(AuthValidators.password('1'), isNull);
  });

  test('password baru: wajib lalu minimal 8 karakter', () {
    expect(AuthValidators.newPassword(null), AuthStrings.passwordRequired);
    expect(AuthValidators.newPassword('1234567'), AuthStrings.passwordTooShort);
    expect(AuthValidators.newPassword('12345678'), isNull);
  });

  test('nama minimal 3 huruf setelah dirapikan', () {
    expect(AuthValidators.name(null), AuthStrings.nameRequired);
    expect(AuthValidators.name(' Al '), AuthStrings.nameRequired);
    expect(AuthValidators.name('Sari'), isNull);
  });

  test('konfirmasi sandi: wajib lalu harus sama', () {
    expect(
      AuthValidators.confirmPassword(null, 'abc'),
      AuthStrings.confirmRequired,
    );
    expect(
      AuthValidators.confirmPassword('abd', 'abc'),
      AuthStrings.confirmMismatch,
    );
    expect(AuthValidators.confirmPassword('abc', 'abc'), isNull);
  });

  test('persetujuan S&K wajib dicentang', () {
    expect(AuthValidators.acceptedTerms(null), AuthStrings.termsRequired);
    expect(AuthValidators.acceptedTerms(false), AuthStrings.termsRequired);
    expect(AuthValidators.acceptedTerms(true), isNull);
  });
}
