import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/widgets/app_shimmer.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/home_skeleton.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets('menampilkan shimmer terpisah pada setiap kartu Beranda', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HomeSkeleton())),
    );

    // 12 widget: sapaan, cari, chip, featured, 2 kartu pasangan, tiket,
    // header jadwal, 3 tile jadwal, dan banner komunitas.
    expect(find.byType(AppShimmer), findsNWidgets(12));
    expect(find.byType(Card), findsWidgets);
    expect(
      tester.widget<Card>(find.byType(Card).first).color,
      AppColors.border,
    );
    final periods = tester
        .widgetList<Shimmer>(find.byType(Shimmer))
        .map((shimmer) => shimmer.period)
        .toList();
    expect(
      periods.where((period) => period == const Duration(milliseconds: 3000)),
      hasLength(1),
    );
    expect(tester.takeException(), isNull);
  });
}
