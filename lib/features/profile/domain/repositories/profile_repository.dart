import '../entities/profile_content.dart';

/// Kontrak sumber data profil pengguna.
abstract class ProfileRepository {
  Future<ProfileContent> fetchProfileContent();
}
