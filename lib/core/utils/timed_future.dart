import 'dart:async';

/// Menjalankan [future] dengan batas waktu [timeout].
///
/// Bila [future] belum selesai tepat waktu, [timeoutError] yang dilempar.
/// Future yang kalah tetap di-consume agar tidak memicu unhandled error.
Future<T> withTimeout<T>(
  Future<T> future,
  Duration timeout,
  Object timeoutError,
) async {
  final completer = Completer<T>();
  final timer = Timer(timeout, () {
    if (!completer.isCompleted) {
      completer.completeError(timeoutError);
    }
  });

  unawaited(
    future.then(
      (value) {
        if (!completer.isCompleted) completer.complete(value);
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
    ),
  );

  try {
    return await completer.future;
  } finally {
    timer.cancel();
  }
}

/// Mengulang [operation] dengan jeda [retryDelay] sampai berhasil atau
/// [timeout] terlampaui.
///
/// Sementara percobaan berjalan, state loading/shimmer tetap dipertahankan
/// pemanggil. Bila batas waktu habis, [timeoutError] yang dilempar.
Future<T> retryUntilTimeout<T>({
  required Future<T> Function() operation,
  required Duration timeout,
  required Duration retryDelay,
  required Object timeoutError,
}) async {
  var active = true;
  final retry = _retryWhileActive<T>(
    operation: operation,
    retryDelay: retryDelay,
    isActive: () => active,
    timeoutError: timeoutError,
  );
  try {
    return await withTimeout(retry, timeout, timeoutError);
  } finally {
    // Hentikan loop bila batas waktu tercapai agar tidak ada request yang
    // masih berjalan setelah pemanggil menerima error.
    active = false;
  }
}

Future<T> _retryWhileActive<T>({
  required Future<T> Function() operation,
  required Duration retryDelay,
  required bool Function() isActive,
  required Object timeoutError,
}) async {
  while (isActive()) {
    try {
      return await operation();
    } on Object {
      await Future<void>.delayed(retryDelay);
    }
  }
  throw timeoutError;
}
