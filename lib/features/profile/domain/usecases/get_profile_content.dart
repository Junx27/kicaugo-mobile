import '../entities/profile_content.dart';
import '../repositories/profile_repository.dart';

/// Usecase memuat konten halaman Profil.
class GetProfileContent {
  const GetProfileContent(this._repository);

  final ProfileRepository _repository;

  Future<ProfileContent> call() => _repository.fetchProfileContent();
}
