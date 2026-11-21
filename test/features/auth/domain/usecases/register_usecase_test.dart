import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/register_usecase.dart';

import '../../../../support/fakes.dart';

void main() {
  test('meneruskan data akun baru ke repository', () async {
    final repository = FakeAuthRepository();
    final register = RegisterUseCase(repository);

    final user = await register(
      name: 'Sari',
      identifier: 'sari@kicaugo.id',
      password: 'rahasia123',
    );

    expect(repository.registerCalls, 1);
    expect(user.name, 'Sari');
    expect(user.identifier, 'sari@kicaugo.id');
  });
}
