import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Usecase untuk mendaftarkan akun baru.
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String name,
    required String identifier,
    required String password,
  }) {
    return _repository.register(
      name: name,
      identifier: identifier,
      password: password,
    );
  }
}
