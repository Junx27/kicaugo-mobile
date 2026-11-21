import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';

import '../../../../support/fakes.dart';

void main() {
  test('mengembalikan konten dari repository', () async {
    final repository = FakeHomeRepository();

    final content = await GetHomeContent(repository)();

    expect(repository.fetchCalls, 1);
    expect(content, sampleHomeContent);
  });
}
