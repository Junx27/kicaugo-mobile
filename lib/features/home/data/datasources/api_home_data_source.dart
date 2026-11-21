import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../../domain/entities/home_content.dart';
import 'home_content_dto.dart';
import 'home_data_source.dart';

/// Sumber data Beranda yang memakai backend KicauGo.
class ApiHomeDataSource implements HomeDataSource {
  const ApiHomeDataSource(this._client);

  final ApiClient _client;

  @override
  Future<HomeContent> fetchHomeContent() async {
    final json = await _client.getJson(ApiPaths.home);
    return HomeContentDto.fromJson(json);
  }
}
