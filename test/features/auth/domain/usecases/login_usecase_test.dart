import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/login_usecase.dart';

import '../../../../support/fakes.dart';

void main() {
  test('meneruskan identifier dan sandi ke repository', () async {
    final repository = FakeAuthRepository();
    final login = LoginUseCase(repository);

    final user = await login(identifier: '08123456789', password: 'rahasia123');

    expect(repository.loginCalls, 1);
    expect(user.identifier, '08123456789');
  });
}
