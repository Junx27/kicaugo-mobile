/// Aturan bisnis kredensial yang dipakai validasi form dan sumber data.
abstract final class AuthRules {
  /// Panjang minimal kata sandi akun baru.
  static const int minPasswordLength = 8;

  /// Panjang minimal nama lengkap.
  static const int minNameLength = 3;

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// 08xx / 628xx / +628xx dengan total 10–13 digit setelah awalan `0`.
  static final RegExp _phone = RegExp(r'^(?:\+62|62|0)8\d{8,11}$');

  static final RegExp _phoneSeparators = RegExp(r'[\s-]');

  /// Apakah [value] berupa alamat email.
  static bool isEmail(String value) => _email.hasMatch(value.trim());

  /// Apakah [value] berupa nomor WhatsApp Indonesia (spasi/strip diabaikan).
  static bool isPhone(String value) =>
      _phone.hasMatch(value.trim().replaceAll(_phoneSeparators, ''));

  /// Bentuk baku identifier untuk pencocokan akun: email huruf kecil, nomor
  /// WhatsApp tanpa pemisah dengan awalan `0`.
  static String normalize(String value) {
    final trimmed = value.trim().toLowerCase();
    if (!isPhone(trimmed)) {
      return trimmed;
    }
    final digits = trimmed.replaceAll(_phoneSeparators, '');
    return digits.replaceFirst(_phoneCountryPrefix, '0');
  }

  static final RegExp _phoneCountryPrefix = RegExp(r'^(?:\+62|62)');

  /// Identitas login yang sah: email atau nomor WhatsApp.
  static bool isValidIdentifier(String value) =>
      isEmail(value) || isPhone(value);
}
