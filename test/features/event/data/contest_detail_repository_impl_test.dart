import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/fake_contest_detail_data_source.dart';
import 'package:rumahkicau_mobile/features/event/data/repositories/contest_detail_repository_impl.dart';

void main() {
  test('fetchContestDetail diteruskan ke sumber data', () async {
    const repository = ContestDetailRepositoryImpl(
      FakeContestDetailDataSource(),
    );

    final detail = await repository.fetchContestDetail(9);

    expect(detail.id, FakeContestDetailDataSource.content.id);
  });
}
