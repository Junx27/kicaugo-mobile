import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../../domain/entities/home_content.dart';
import 'home_content_dto.dart';
import 'home_data_source.dart';

/// Sumber data Beranda yang memakai backend KicauGo.
///
/// Profil diambil dari `/api/v1/home/profile`, lomba unggulan dari
/// `/api/v1/home/featured`, dan kategori burung dari
/// `/api/v1/home/bird-categories`. Kegagalan backend apa pun diteruskan ke
/// pemanggil agar shimmer bisa retry dan akhirnya menampilkan tombol coba lagi.
class ApiHomeDataSource implements HomeDataSource {
  const ApiHomeDataSource(this._client);

  final ApiClient _client;

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    final json = await _client.getJson(
      '${ApiPaths.homeProfile}?radius_km=$radiusKm&category_id=$categoryId&limit=$limit',
    );
    final profile = HomeContentDto.profileFromJson(json);

    final featuredJson = await _client.getJson(ApiPaths.homeFeatured);
    final featured = HomeContentDto.featuredFromJson(featuredJson);

    final categoriesJson = await _client.getJson(ApiPaths.homeBirdCategories);
    final categories = HomeContentDto.birdCategoriesFromJson(categoriesJson);

    // Bagian yang belum disediakan backend masih memakai data contoh.
    const demo = HomeDemoDataSource.content;
    return HomeContent(
      profile: profile,
      featured: featured,
      upcoming: demo.upcoming,
      stats: demo.stats,
      activeTicket: demo.activeTicket,
      schedules: demo.schedules,
      categories: categories,
    );
  }
}
