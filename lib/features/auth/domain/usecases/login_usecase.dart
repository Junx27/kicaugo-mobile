import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Usecase untuk masuk dengan email/nomor WhatsApp dan kata sandi.
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({required String identifier, required String password}) {
    return _repository.login(identifier: identifier, password: password);
  }
}
