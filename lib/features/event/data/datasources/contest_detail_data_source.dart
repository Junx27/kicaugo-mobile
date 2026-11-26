import '../../domain/entities/contest_detail.dart';

/// Kontrak sumber data detail lomba.
abstract interface class ContestDetailDataSource {
  Future<ContestDetail> fetchContestDetail(int id);
}
