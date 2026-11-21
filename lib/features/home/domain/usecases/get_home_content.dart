import '../entities/home_content.dart';
import '../repositories/home_repository.dart';

/// Usecase untuk mengambil seluruh konten Beranda.
class GetHomeContent {
  const GetHomeContent(this._repository);

  final HomeRepository _repository;

  Future<HomeContent> call() => _repository.fetchHomeContent();
}
