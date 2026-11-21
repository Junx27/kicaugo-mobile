import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/community/domain/usecases/get_community_content.dart';

import '../support/community_fakes.dart';

void main() {
  test('mengembalikan konten dari repository', () async {
    final repository = FakeCommunityRepository();

    final content = await GetCommunityContent(repository)();

    expect(content, sampleCommunity);
    expect(repository.calls, 1);
  });
}
