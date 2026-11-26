import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/api_contest_detail_data_source.dart';

import '../../../support/fake_http.dart';
import '../support/contest_detail_fixture.dart';

void main() {
  test('fetchContestDetail memetakan payload backend', () async {
    final adapter = FakeHttpAdapter(body: jsonEncode(contestDetailPayload()));
    final dataSource = ApiContestDetailDataSource(
      ApiClient(testDio(adapter), FakeTokenProvider('jwt-token')),
    );

    final detail = await dataSource.fetchContestDetail(101);

    expect(adapter.recordedOptions?.path, contestDetailPath);
    expect(detail.id, 101);
    expect(detail.header.title, 'Piala Raja Nusantara 2025');
    expect(detail.info.ticket.startingPrice, 'Rp 150.000');
    expect(detail.classes.single.name, 'Murai Batu Utama');
    expect(detail.rules.single.title, 'Aturan Sangkar');
  });
}
