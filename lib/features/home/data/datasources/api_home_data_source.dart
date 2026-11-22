import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../../domain/entities/home_content.dart';
import 'home_content_dto.dart';
import 'home_data_source.dart';

/// Sumber data Beranda yang memakai backend KicauGo.
///
/// Endpoint `/api/v1/home` belum tersedia di backend saat ini, sehingga bila
/// permintaan gagal karena endpoint tidak ada atau masalah jaringan, sumber
/// data ini kembali ke data dummy agar Beranda tetap bisa dimuat. Kegagalan
/// lain (mis. 5xx dengan pesan server) tetap diteruskan.
class ApiHomeDataSource implements HomeDataSource {
  const ApiHomeDataSource(
    this._client, {
    this.fallback = const HomeDemoDataSource(),
  });

  final ApiClient _client;
  final HomeDataSource fallback;

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    HomeSummary summary;
    try {
      final json = await _client.getJson(
        '${ApiPaths.homeProfile}?radius_km=$radiusKm&category_id=$categoryId&limit=$limit',
      );
      summary = HomeContentDto.summaryFromProfileJson(json);
    } on Failure catch (failure) {
      if (_shouldFallback(failure)) {
        return fallback.fetchHomeContent(
          radiusKm: radiusKm,
          categoryId: categoryId,
          limit: limit,
        );
      }
      rethrow;
    }

    const demo = HomeDemoDataSource.content;
    return HomeContent(
      summary: summary,
      featured: demo.featured,
      upcoming: demo.upcoming,
      stats: demo.stats,
      activeTicket: demo.activeTicket,
      schedules: demo.schedules,
    );
  }

  bool _shouldFallback(Failure failure) =>
      failure is DataFailure &&
      (failure.message == AppConstants.apiDataFailure ||
          failure.message == AppConstants.apiTimeoutMessage ||
          failure.message == AppConstants.apiConnection ||
          failure.message == AppConstants.apiUnexpected);
}
