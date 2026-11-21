import '../entities/community_content.dart';

/// Kontrak akses data Komunitas.
abstract interface class CommunityRepository {
  Future<CommunityContent> fetchCommunityContent();
}
