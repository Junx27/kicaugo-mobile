import '../entities/home_content.dart';

/// Kontrak repository Beranda.
abstract interface class HomeRepository {
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  });
}
