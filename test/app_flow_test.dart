import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/app.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/fake_contest_detail_data_source.dart';
import 'package:rumahkicau_mobile/features/event/data/repositories/contest_detail_repository_impl.dart';
import 'package:rumahkicau_mobile/features/event/domain/usecases/get_contest_detail.dart';

import 'support/fakes.dart';
import 'support/pump_app.dart';

void main() {
  test('root widget dapat dibuat', () {
    final authBloc = createAuthBloc();
    addTearDown(authBloc.close);

    expect(
      KicauKuApp(
        key: UniqueKey(),
        authBloc: authBloc,
        getHomeContent: defaultGetHomeContent(),
        getContestDetail: const GetContestDetail(
          ContestDetailRepositoryImpl(FakeContestDetailDataSource()),
        ),
        locationService: const NoLocationService(),
        routeService: FakeRouteService(),
        updateCurrentLocation: defaultUpdateCurrentLocation(),
      ),
      isA<KicauKuApp>(),
    );
  });

  testWidgets('router dan listener dibuang saat aplikasi ditutup', (
    tester,
  ) async {
    await pumpKicauKuApp(tester);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
