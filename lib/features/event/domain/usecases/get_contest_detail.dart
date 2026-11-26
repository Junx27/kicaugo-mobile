import '../entities/contest_detail.dart';
import '../repositories/contest_detail_repository.dart';

/// Use case untuk mengambil detail lomba berdasarkan id.
class GetContestDetail {
  const GetContestDetail(this._repository);

  final ContestDetailRepository _repository;

  Future<ContestDetail> call(int id) => _repository.fetchContestDetail(id);
}
