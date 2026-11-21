import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/logging/app_logger.dart';

/// Menangkap keluaran `debugPrint` selama satu test.
List<String?> captureDebugPrint() {
  final captured = <String?>[];
  final previous = debugPrint;
  debugPrint = (String? message, {int? wrapWidth}) => captured.add(message);
  addTearDown(() => debugPrint = previous);
  return captured;
}

void main() {
  late List<String> lines;

  setUp(() {
    lines = <String>[];
    AppLogger.enabled = true;
    AppLogger.colorEnabled = false;
    AppLogger.setSink(lines.add);
  });

  tearDown(() {
    AppLogger.setSink(null);
    AppLogger.enabled = kDebugMode;
    AppLogger.colorEnabled = false;
  });

  test('menulis baris log dengan tag', () {
    AppLogger.log('API', 'REQUEST GET /home');

    expect(lines, <String>['[API] REQUEST GET /home']);
  });

  test('tidak menulis apa pun saat dinonaktifkan', () {
    AppLogger.enabled = false;

    AppLogger.log('NAV', 'PUSH /login');

    expect(lines, isEmpty);
  });

  test('colorizeLog menghasilkan ANSI per baris saat flag aktif', () {
    final result = colorizeLog(
      '[API] PAYLOAD\n{\n  "password": "***"\n}',
      enabled: true,
      color: '\x1B[34m',
    );

    expect(
      result,
      '\x1B[34m[API] PAYLOAD\x1B[0m\n'
      '\x1B[34m{\x1B[0m\n'
      '\x1B[34m  "password": "***"\x1B[0m\n'
      '\x1B[34m}\x1B[0m',
    );
  });

  test('colorizeLog mengembalikan teks polos saat flag nonaktif', () {
    expect(
      colorizeLog('[BOOT] flavor=dev', enabled: false, color: '\x1B[32m'),
      '[BOOT] flavor=dev',
    );
  });

  test('colorizeLog mengembalikan teks polos saat warna tidak ada', () {
    expect(colorizeLog('[OTHER] plain', enabled: true), '[OTHER] plain');
  });

  test('tanpa warna di debugPrint saat colorEnabled nonaktif', () {
    final captured = captureDebugPrint();
    AppLogger.setSink(null);

    AppLogger.log('BOOT', 'flavor=dev');
    AppLogger.log('API', 'REQUEST GET /home');

    expect(captured, <String?>['[BOOT] flavor=dev', '[API] REQUEST GET /home']);
  });

  test('memberi warna per tag di debugPrint saat colorEnabled aktif', () {
    final captured = captureDebugPrint();
    AppLogger.setSink(null);
    AppLogger.colorEnabled = true;

    AppLogger.log('BOOT', 'flavor=dev');
    AppLogger.log('API', 'REQUEST GET /home');
    AppLogger.log('ERR', 'ERROR 401 GET /home');
    AppLogger.log('NAV', 'PUSH /login');

    expect(captured[0], '\x1B[32m[BOOT] flavor=dev\x1B[0m');
    expect(captured[1], '\x1B[34m[API] REQUEST GET /home\x1B[0m');
    expect(captured[2], '\x1B[31m[ERR] ERROR 401 GET /home\x1B[0m');
    expect(captured[3], '\x1B[35m[NAV] PUSH /login\x1B[0m');
  });

  test('setiap baris payload tetap berwarna', () {
    final captured = captureDebugPrint();
    AppLogger.setSink(null);
    AppLogger.colorEnabled = true;

    AppLogger.log('API', 'PAYLOAD\n{\n  "password": "***"\n}');

    expect(captured.single, contains('\x1B[34m{\x1B[0m'));
    expect(captured.single, contains('\x1B[34m  "password": "***"\x1B[0m'));
    expect(captured.single, contains('\x1B[34m}\x1B[0m'));
  });

  test('colorCode mengganti warna bawaan tag', () {
    final captured = captureDebugPrint();
    AppLogger.setSink(null);
    AppLogger.colorEnabled = true;

    AppLogger.log('API', 'RESPONSE 200 GET /home', colorCode: AppLogger.green);
    AppLogger.log('API', 'RESPONSE 500 GET /home', colorCode: AppLogger.red);

    expect(captured[0], startsWith('\x1B[32m[API]'));
    expect(captured[1], startsWith('\x1B[31m[API]'));
  });

  test('sink tetap menerima teks polos walau warna aktif', () {
    AppLogger.colorEnabled = true;

    AppLogger.log('BOOT', 'flavor=dev');

    expect(lines, <String>['[BOOT] flavor=dev']);
  });

  test('tanpa warna untuk tag yang tidak dikenal', () {
    final captured = captureDebugPrint();
    AppLogger.setSink(null);
    AppLogger.colorEnabled = true;

    AppLogger.log('OTHER', 'plain');

    expect(captured, <String?>['[OTHER] plain']);
  });
}
