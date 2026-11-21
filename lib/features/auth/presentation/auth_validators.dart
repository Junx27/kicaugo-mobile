import '../domain/rules/auth_rules.dart';
import 'auth_strings.dart';

/// Validator formulir masuk/daftar; mengembalikan pesan atau `null` bila sah.
abstract final class AuthValidators {
  static String? identifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return AuthStrings.identifierRequired;
    }
    return AuthRules.isValidIdentifier(text)
        ? null
        : AuthStrings.identifierInvalid;
  }

  /// Sandi login: cukup wajib diisi (aturan panjang hanya untuk akun baru).
  static String? password(String? value) =>
      (value ?? '').isEmpty ? AuthStrings.passwordRequired : null;

  static String? newPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return AuthStrings.passwordRequired;
    }
    return text.length < AuthRules.minPasswordLength
        ? AuthStrings.passwordTooShort
        : null;
  }

  static String? name(String? value) =>
      (value ?? '').trim().length < AuthRules.minNameLength
      ? AuthStrings.nameRequired
      : null;

  static String? confirmPassword(String? value, String original) {
    final text = value ?? '';
    if (text.isEmpty) {
      return AuthStrings.confirmRequired;
    }
    return text == original ? null : AuthStrings.confirmMismatch;
  }

  static String? acceptedTerms(bool? value) =>
      value == true ? null : AuthStrings.termsRequired;
}
