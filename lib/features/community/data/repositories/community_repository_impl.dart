import '../../domain/entities/community_content.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_data_source.dart';

/// Implementasi [CommunityRepository] yang meneruskan ke sumber data.
class CommunityRepositoryImpl implements CommunityRepository {
  const CommunityRepositoryImpl(this._dataSource);

  final CommunityDataSource _dataSource;

  @override
  Future<CommunityContent> fetchCommunityContent() =>
      _dataSource.fetchCommunityContent();
}
