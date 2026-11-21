import 'package:flutter/foundation.dart';

/// Warna ANSI aktif secara default. Matikan lewat
/// `--dart-define=LOG_COLOR=false` (misalnya untuk Debug Console VS Code).
const bool logColorEnabled = bool.fromEnvironment(
  'LOG_COLOR',
  defaultValue: true,
);

const String _resetColor = '\x1B[0m';
const String _green = '\x1B[32m';
const String _blue = '\x1B[34m';
const String _red = '\x1B[31m';
const String _magenta = '\x1B[35m';

/// Warna bawaan per tag. Tag tetap ditulis sebagai teks biasa.
const Map<String, String> _tagColors = <String, String>{
  'BOOT': _green,
  'API': _blue,
  'ERR': _red,
  'NAV': _magenta,
};

/// Membungkus setiap baris [text] dengan warna [color] dan reset.
///
/// Fungsi murni supaya cabang warna bisa diuji tanpa bergantung pada
/// `bool.fromEnvironment`. Baris diwarnai satu per satu agar JSON multi-baris
/// tidak kehilangan warna di tengah output.
String colorizeLog(String text, {required bool enabled, String? color}) {
  if (!enabled || color == null) return text;
  return text.split('\n').map((line) => '$color$line$_resetColor').join('\n');
}

/// Pencatat log ringan untuk kebutuhan debugging.
///
/// Hanya menulis saat `kDebugMode`; sink bisa diganti lewat [setSink] untuk
/// keperluan test dan selalu menerima teks polos tanpa ANSI.
abstract final class AppLogger {
  /// Aktif/nonaktifkan pencatatan log secara global.
  static bool enabled = kDebugMode;

  /// Aktif/nonaktifkan warna ANSI. Bisa dioverride di test.
  /// Warna ANSI tidak dirender di iOS (log stream via Xcode/simctl meng-escape
  /// ESC), jadi nonaktifkan otomatis di platform iOS agar output tetap bersih.
  static bool colorEnabled =
      logColorEnabled &&
      kDebugMode &&
      defaultTargetPlatform != TargetPlatform.iOS;

  /// Hijau untuk respons API sukses.
  static const String green = _green;

  /// Merah untuk respons API gagal.
  static const String red = _red;

  static void Function(String line)? _sink;

  /// Mengganti tujuan log. `null` mengembalikan tujuan ke `debugPrint`.
  static void setSink(void Function(String line)? sink) => _sink = sink;

  /// Menulis log bila [enabled] dan aplikasi berada di mode debug.
  ///
  /// [colorCode] mengganti warna bawaan tag, misalnya hijau untuk respons 2xx
  /// atau merah untuk respons 4xx/5xx.
  static void log(
    String tag,
    String message, {
    String? colorCode,
    String? icon,
  }) {
    if (!enabled || !kDebugMode) return;

    final sink = _sink;
    final line = icon == null ? '[$tag] $message' : '$icon [$tag] $message';
    if (sink != null) {
      sink(line);
      return;
    }
    final color = colorCode ?? _tagColors[tag];
    debugPrint(colorizeLog(line, enabled: colorEnabled, color: color));
  }
}
