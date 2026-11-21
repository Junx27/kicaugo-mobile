import '../repositories/auth_repository.dart';

/// Usecase untuk mengakhiri sesi.
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
