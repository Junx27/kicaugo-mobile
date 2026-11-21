import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/logging/app_logger.dart';
import 'package:rumahkicau_mobile/core/router/app_navigator_observer.dart';

Route<dynamic> _route(String? name) => MaterialPageRoute<dynamic>(
  settings: RouteSettings(name: name),
  builder: (_) => const SizedBox.shrink(),
);

void main() {
  late List<String> lines;
  late AppNavigatorObserver observer;

  setUp(() {
    lines = <String>[];
    observer = AppNavigatorObserver();
    AppLogger.enabled = true;
    AppLogger.setSink(lines.add);
  });

  tearDown(() => AppLogger.setSink(null));

  test('mencatat halaman yang dibuka beserta halaman sebelumnya', () {
    observer.didPush(_route('/home'), _route('/login'));

    expect(lines, <String>['🚀 [NAV] PUSH /home from /login']);
  });

  test('mencatat halaman yang ditutup beserta halaman tujuannya', () {
    observer.didPop(_route('/login'), _route('/home'));

    expect(lines, <String>['🔙 [NAV] POP /login to /home']);
  });

  test('memakai tipe route bila nama tidak tersedia', () {
    observer.didPush(_route(null), null);

    expect(lines.single, contains('PUSH MaterialPageRoute'));
    expect(lines.single, contains('from unknown'));
  });
}
