import '../../domain/entities/home_content.dart';

/// Kontrak sumber data Beranda.
abstract interface class HomeDataSource {
  Future<HomeContent> fetchHomeContent();
}
