import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../support/fakes.dart';

void main() {
  test('memanggil logout pada repository', () async {
    final repository = FakeAuthRepository();
    final logout = LogoutUseCase(repository);

    await logout();

    expect(repository.logoutCalls, 1);
  });
}
