import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/event/domain/usecases/get_contest_detail.dart';

import '../../support/contest_detail_fixture.dart';

void main() {
  test('memanggil repository dengan id yang diberikan', () async {
    final repository = StubContestDetailRepository();
    final getContestDetail = GetContestDetail(repository);

    final detail = await getContestDetail(9);

    expect(repository.lastId, 9);
    expect(detail.id, 101);
  });
}
