import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/community/data/datasources/community_data_source.dart';
import 'package:rumahkicau_mobile/features/community/data/repositories/community_repository_impl.dart';
import 'package:rumahkicau_mobile/features/community/domain/entities/community_content.dart';

import '../support/community_fakes.dart';

class _RecordingDataSource implements CommunityDataSource {
  int calls = 0;

  @override
  Future<CommunityContent> fetchCommunityContent() async {
    calls++;
    return sampleCommunity;
  }
}

void main() {
  test('meneruskan permintaan konten ke sumber data', () async {
    final dataSource = _RecordingDataSource();

    final content = await CommunityRepositoryImpl(
      dataSource,
    ).fetchCommunityContent();

    expect(dataSource.calls, 1);
    expect(content, sampleCommunity);
  });
}
