import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/app.dart';

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
