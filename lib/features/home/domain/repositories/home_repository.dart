import '../entities/home_content.dart';

/// Kontrak akses data Beranda.
abstract interface class HomeRepository {
  Future<HomeContent> fetchHomeContent();
}
