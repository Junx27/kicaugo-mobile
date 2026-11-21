import '../../domain/entities/community_content.dart';

/// Kontrak sumber data Komunitas.
abstract interface class CommunityDataSource {
  Future<CommunityContent> fetchCommunityContent();
}
