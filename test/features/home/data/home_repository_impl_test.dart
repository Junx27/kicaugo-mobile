import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_content.dart';

import '../../../support/fakes.dart';

class _RecordingHomeDataSource implements HomeDataSource {
  int fetchCalls = 0;

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    fetchCalls++;
    return sampleHomeContent;
  }
}

void main() {
  test('meneruskan permintaan konten ke sumber data', () async {
    final dataSource = _RecordingHomeDataSource();
    final repository = HomeRepositoryImpl(dataSource);

    final content = await repository.fetchHomeContent();

    expect(dataSource.fetchCalls, 1);
    expect(content, sampleHomeContent);
  });
}
