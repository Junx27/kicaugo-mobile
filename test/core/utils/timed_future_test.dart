import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/utils/timed_future.dart';

void main() {
  const timeoutError = DataFailure('timeout');

  test('mengembalikan nilai bila future selesai sebelum batas waktu', () async {
    final result = await withTimeout<int>(
      Future<int>.value(7),
      const Duration(seconds: 1),
      timeoutError,
    );

    expect(result, 7);
  });

  test('meneruskan error future yang lebih cepat dari batas waktu', () async {
    await expectLater(
      withTimeout<int>(
        Future<int>.error(const DataFailure('gagal')),
        const Duration(seconds: 1),
        timeoutError,
      ),
      throwsA(
        isA<DataFailure>().having((error) => error.message, 'message', 'gagal'),
      ),
    );
  });

  test('melempar timeoutError bila future terlalu lama', () async {
    final completer = Completer<int>();

    await expectLater(
      withTimeout<int>(
        completer.future,
        const Duration(milliseconds: 20),
        timeoutError,
      ),
      throwsA(
        isA<DataFailure>().having(
          (error) => error.message,
          'message',
          'timeout',
        ),
      ),
    );
  });

  test('mengabaikan nilai yang datang setelah timeout', () async {
    final completer = Completer<int>();
    final result = withTimeout<int>(
      completer.future,
      const Duration(milliseconds: 20),
      timeoutError,
    );

    await expectLater(result, throwsA(isA<DataFailure>()));
    completer.complete(9);
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });

  test('mengabaikan error yang datang setelah timeout', () async {
    final completer = Completer<int>();
    final result = withTimeout<int>(
      completer.future,
      const Duration(milliseconds: 20),
      timeoutError,
    );

    await expectLater(result, throwsA(isA<DataFailure>()));
    completer.completeError(const DataFailure('telat'));
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });

  group('retryUntilTimeout', () {
    test(
      'langsung mengembalikan nilai bila percobaan pertama sukses',
      () async {
        var attempts = 0;
        final result = await retryUntilTimeout<int>(
          operation: () async {
            attempts++;
            return 7;
          },
          timeout: const Duration(milliseconds: 60),
          retryDelay: const Duration(milliseconds: 5),
          timeoutError: timeoutError,
        );

        expect(result, 7);
        expect(attempts, 1);
      },
    );

    test('mengulang operasi sampai sukses dalam batas waktu', () async {
      var attempts = 0;
      final result = await retryUntilTimeout<int>(
        operation: () async {
          attempts++;
          if (attempts < 3) throw const DataFailure('gagal sementara');
          return 11;
        },
        timeout: const Duration(milliseconds: 80),
        retryDelay: const Duration(milliseconds: 5),
        timeoutError: timeoutError,
      );

      expect(result, 11);
      expect(attempts, 3);
    });

    test('melempar timeoutError bila semua percobaan gagal', () async {
      var attempts = 0;
      await expectLater(
        retryUntilTimeout<int>(
          operation: () async {
            attempts++;
            throw const DataFailure('gagal terus');
          },
          timeout: const Duration(milliseconds: 30),
          retryDelay: const Duration(milliseconds: 5),
          timeoutError: timeoutError,
        ),
        throwsA(
          isA<DataFailure>().having(
            (error) => error.message,
            'message',
            'timeout',
          ),
        ),
      );
      expect(attempts, greaterThan(1));
    });
  });
}
