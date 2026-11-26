import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../../domain/entities/contest_detail.dart';
import 'contest_detail_data_source.dart';
import 'contest_detail_dto.dart';

/// Sumber data detail lomba yang memakai backend.
class ApiContestDetailDataSource implements ContestDetailDataSource {
  const ApiContestDetailDataSource(this._client);

  final ApiClient _client;

  @override
  Future<ContestDetail> fetchContestDetail(int id) async {
    final json = await _client.getJson('${ApiPaths.contestDetail}/$id');
    return ContestDetailDto.fromJson(json);
  }
}
