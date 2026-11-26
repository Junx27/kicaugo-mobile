import '../entities/contest_detail.dart';

/// Kontrak repository detail lomba.
abstract interface class ContestDetailRepository {
  Future<ContestDetail> fetchContestDetail(int id);
}
