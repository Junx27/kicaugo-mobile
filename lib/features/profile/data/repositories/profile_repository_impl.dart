import '../../domain/entities/profile_content.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_source.dart';

/// Implementasi repository Profil di atas [ProfileDataSource].
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileDataSource _dataSource;

  @override
  Future<ProfileContent> fetchProfileContent() =>
      _dataSource.fetchProfileContent();
}
