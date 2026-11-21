import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/community/data/datasources/fake_community_data_source.dart';
import 'package:rumahkicau_mobile/features/community/domain/entities/community_content.dart';
import 'package:rumahkicau_mobile/features/community/domain/repositories/community_repository.dart';

/// Konten demo Komunitas untuk test.
const CommunityContent sampleCommunity = FakeCommunityDataSource.content;

/// Pesan gagal yang dilempar [FakeCommunityRepository].
const String communityFailure = 'Gagal memuat komunitas';

/// Repository Komunitas palsu yang bisa gagal beberapa kali.
class FakeCommunityRepository implements CommunityRepository {
  FakeCommunityRepository({this.failuresRemaining = 0});

  int failuresRemaining;
  int calls = 0;

  @override
  Future<CommunityContent> fetchCommunityContent() async {
    calls++;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure(communityFailure);
    }
    return sampleCommunity;
  }
}
