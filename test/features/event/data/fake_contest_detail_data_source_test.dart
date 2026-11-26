import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/fake_contest_detail_data_source.dart';

void main() {
  test(
    'fetchContestDetail menunggu delay lalu mengembalikan konten dummy',
    () async {
      const dataSource = FakeContestDetailDataSource(
        delay: Duration(milliseconds: 1),
      );

      final detail = await dataSource.fetchContestDetail(7);

      expect(detail, FakeContestDetailDataSource.content);
    },
  );
}
