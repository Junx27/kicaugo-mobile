import '../../domain/entities/profile_content.dart';

/// Kontrak sumber data profil (demo atau API).
abstract class ProfileDataSource {
  Future<ProfileContent> fetchProfileContent();
}
