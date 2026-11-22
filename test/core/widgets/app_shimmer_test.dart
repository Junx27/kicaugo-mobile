import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/widgets/app_shimmer.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets('membungkus child dengan Shimmer standar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppShimmer(child: SizedBox(height: 8))),
    );

    final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    expect(shimmer.enabled, isTrue);
    expect(shimmer.period, const Duration(milliseconds: 1200));
    final gradient = shimmer.gradient as LinearGradient;
    expect(gradient.colors, <Color>[
      AppColors.border,
      AppColors.border,
      AppColors.surfaceLavender,
      AppColors.border,
      AppColors.border,
    ]);
    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('durasi bisa diganti untuk pengujian', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShimmer(
          period: Duration(milliseconds: 3000),
          child: SizedBox(height: 8),
        ),
      ),
    );

    expect(
      tester.widget<Shimmer>(find.byType(Shimmer)).period,
      const Duration(milliseconds: 3000),
    );
  });

  testWidgets('menerima child yang dibuat saat runtime', (tester) async {
    final child = SizedBox(height: tester.view.devicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: AppShimmer(child: child)));

    expect(find.byWidget(child), findsOneWidget);
  });

  testWidgets('animasi bisa dinonaktifkan', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShimmer(enabled: false, child: SizedBox(height: 8)),
      ),
    );

    expect(tester.widget<Shimmer>(find.byType(Shimmer)).enabled, isFalse);
  });
}
