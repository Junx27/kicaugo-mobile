import '../../domain/entities/contest_detail.dart';
import '../../domain/repositories/contest_detail_repository.dart';
import '../datasources/contest_detail_data_source.dart';

/// Implementasi [ContestDetailRepository] yang meneruskan ke sumber data.
class ContestDetailRepositoryImpl implements ContestDetailRepository {
  const ContestDetailRepositoryImpl(this._dataSource);

  final ContestDetailDataSource _dataSource;

  @override
  Future<ContestDetail> fetchContestDetail(int id) =>
      _dataSource.fetchContestDetail(id);
}
