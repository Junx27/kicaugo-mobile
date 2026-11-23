import '../../domain/entities/home_content.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_data_source.dart';

/// Implementasi [HomeRepository] yang meneruskan ke sumber data.
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeDataSource _dataSource;

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) => _dataSource.fetchHomeContent(
    radiusKm: radiusKm,
    categoryId: categoryId,
    limit: limit,
  );
}
