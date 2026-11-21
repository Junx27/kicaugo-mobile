import '../../domain/entities/help_center_content.dart';
import '../../domain/repositories/help_center_repository.dart';
import '../datasources/help_center_data_source.dart';

/// Implementasi repository Pusat Bantuan di atas [HelpCenterDataSource].
class HelpCenterRepositoryImpl implements HelpCenterRepository {
  const HelpCenterRepositoryImpl(this._dataSource);

  final HelpCenterDataSource _dataSource;

  @override
  Future<HelpCenterContent> fetchHelpCenterContent() =>
      _dataSource.fetchHelpCenterContent();
}
