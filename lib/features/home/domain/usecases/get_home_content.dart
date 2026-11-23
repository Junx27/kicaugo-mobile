import '../entities/home_content.dart';
import '../repositories/home_repository.dart';

/// Use case untuk mengambil konten Beranda.
class GetHomeContent {
  const GetHomeContent(this._repository);

  final HomeRepository _repository;

  Future<HomeContent> call({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) => _repository.fetchHomeContent(
    radiusKm: radiusKm,
    categoryId: categoryId,
    limit: limit,
  );
}
