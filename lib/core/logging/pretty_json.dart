import 'dart:convert';

const int _maxBodyLength = 4000;
const String _truncatedSuffix = '... (truncated)';
const String _mask = '***';

/// Kunci yang nilainya disembunyikan di log, termasuk variasi umum token.
const Set<String> _sensitiveKeys = <String>{
  'authorization',
  'password',
  'token',
  'accesstoken',
  'refreshtoken',
  'secret',
  'apikey',
};

/// Mengurai string JSON objek/array; null bila bukan JSON.
Object? decodeJsonBody(String text) {
  if (!text.startsWith('{') && !text.startsWith('[')) return null;
  try {
    return jsonDecode(text);
  } catch (_) {
    return null;
  }
}

/// Menampilkan [data] sebagai JSON berindentasi dua spasi.
///
/// String JSON diurai dulu; string biasa dikembalikan apa adanya.
String prettyJson(Object? data) {
  if (data is String) {
    final decoded = decodeJsonBody(data);
    return decoded == null ? data : _encode(decoded);
  }
  return _encode(data);
}

/// Menentukan apakah sebuah kunci tergolong sensitif (case-insensitive).
bool isSensitiveLogKey(Object? key) =>
    _sensitiveKeys.contains(key.toString().toLowerCase());

/// Mengganti nilai sensitif di map, list, dan string JSON sebelum pretty-print.
Object? maskSensitiveValues(Object? value) {
  if (value is Map) {
    return value.map(
      (key, item) => MapEntry(
        key,
        isSensitiveLogKey(key) ? _mask : maskSensitiveValues(item),
      ),
    );
  }
  if (value is List) return value.map(maskSensitiveValues).toList();
  final decoded = value is String ? decodeJsonBody(value) : null;
  return decoded == null ? value : maskSensitiveValues(decoded);
}

/// Masking dulu pada objek hasil decode, lalu cetak JSON rapi.
String prettyMaskedJson(Object? data) => prettyJson(maskSensitiveValues(data));

/// Memotong body lebih dari 4000 karakter.
String truncateLogBody(String text) => text.length <= _maxBodyLength
    ? text
    : '${text.substring(0, _maxBodyLength)}$_truncatedSuffix';

/// Mengubah objek menjadi JSON rapi, dengan fallback bila tak serializable.
String _encode(Object? value) {
  try {
    return const JsonEncoder.withIndent('  ').convert(value);
  } catch (_) {
    return value.toString();
  }
}
