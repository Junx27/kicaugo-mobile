import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';

void main() {
  test('failure membawa pesan untuk pengguna', () {
    final message = 'Gagal memuat'.toUpperCase();

    final authFailure = AuthFailure(message);
    final dataFailure = DataFailure(message);

    expect(authFailure, isA<Failure>());
    expect(authFailure.message, message);
    expect(dataFailure, isA<Failure>());
    expect(dataFailure.message, message);
  });
}
