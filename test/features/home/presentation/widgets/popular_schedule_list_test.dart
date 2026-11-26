import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/popular_schedule_list.dart';

void main() {
  testWidgets('menampilkan keadaan kosong bila tidak ada jadwal', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PopularScheduleList(items: [])),
      ),
    );

    expect(find.text(HomeStrings.emptySchedules), findsOneWidget);
  });
}
