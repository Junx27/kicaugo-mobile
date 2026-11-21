import '../entities/community_content.dart';
import '../repositories/community_repository.dart';

/// Usecase untuk mengambil seluruh konten Komunitas.
class GetCommunityContent {
  const GetCommunityContent(this._repository);

  final CommunityRepository _repository;

  Future<CommunityContent> call() => _repository.fetchCommunityContent();
}
