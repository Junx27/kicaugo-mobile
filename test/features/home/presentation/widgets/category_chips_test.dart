import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/bird_category_item.dart';
import 'package:rumahkicau_mobile/features/home/presentation/home_strings.dart';
import 'package:rumahkicau_mobile/features/home/presentation/widgets/category_chips.dart';

void _prepareView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _pumpChips(
  WidgetTester tester,
  ValueChanged<String> onSelected, {
  String selectedName = HomeStrings.allCategories,
}) async {
  _prepareView(tester);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CategoryChips(
          categories: HomeDemoDataSource.categories,
          selectedName: selectedName,
          onSelected: onSelected,
        ),
      ),
    ),
  );
}

class _ChipHost extends StatefulWidget {
  const _ChipHost({required this.categories});

  final List<BirdCategoryItem> categories;

  @override
  State<_ChipHost> createState() => _ChipHostState();
}

class _ChipHostState extends State<_ChipHost> {
  String _selected = HomeStrings.allCategories;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: CategoryChips(
        categories: widget.categories,
        selectedName: _selected,
        onSelected: (name) => setState(() => _selected = name),
      ),
    ),
  );
}

void main() {
  testWidgets('menampilkan chip Semua Lomba dan seluruh kategori dari API', (
    tester,
  ) async {
    await _pumpChips(tester, (_) {});

    expect(find.text(HomeStrings.allCategories), findsOneWidget);
    for (final category in HomeDemoDataSource.categories) {
      expect(find.text(category.name), findsOneWidget);
      expect(find.byKey(Key('category-chip-${category.name}')), findsOneWidget);
    }
    expect(find.byType(SvgPicture), findsNWidgets(6));
  });

  testWidgets('chip lavender, aktif primary dengan teks putih tipis', (
    tester,
  ) async {
    await _pumpChips(tester, (_) {}, selectedName: 'Kenari');

    Material chip(String name) =>
        tester.widget<Material>(find.byKey(Key('category-chip-$name')));
    expect(chip('Kenari').color, AppColors.primary);
    expect(chip('Kenari').shadowColor, AppColors.shadow);
    expect(chip('Kenari').elevation, 4);
    expect(chip('Murai Batu').color, AppColors.lavenderGlow);
    expect(chip('Murai Batu').elevation, 2);

    final activeLabel = tester.widget<Text>(find.text('Kenari'));
    expect(activeLabel.style?.fontSize, 10);
    expect(activeLabel.style?.fontWeight, FontWeight.w400);
    expect(activeLabel.style?.color, AppColors.surface);

    final idleLabel = tester.widget<Text>(find.text('Murai Batu'));
    expect(idleLabel.style?.color, AppColors.textSecondary);

    // Ikon SVG tetap memakai warna aslinya (tanpa colorFilter).
    final svg = tester.widget<SvgPicture>(
      find.descendant(
        of: find.byKey(const Key('category-chip-Kenari')),
        matching: find.byType(SvgPicture),
      ),
    );
    expect(svg.colorFilter, isNull);
  });

  testWidgets('mengetuk chip mengirim nama kategori', (tester) async {
    final selected = <String>[];
    await _pumpChips(tester, selected.add);

    await tester.tap(find.byKey(const Key('category-chip-Kenari')));
    await tester.tap(find.byKey(const Key('category-chip-Semua Lomba')));

    expect(selected, <String>['Kenari', HomeStrings.allCategories]);
  });

  testWidgets('nama kategori yang tidak dikenal tidak mengubah urutan', (
    tester,
  ) async {
    await _pumpChips(tester, (_) {}, selectedName: 'Tidak Ada');

    expect(find.text(HomeStrings.allCategories), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(6));
  });

  testWidgets('kategori terpilih bergeser ke setelah Semua Lomba', (
    tester,
  ) async {
    _prepareView(tester);
    await tester.pumpWidget(
      const _ChipHost(categories: HomeDemoDataSource.categories),
    );

    await tester.tap(find.byKey(const Key('category-chip-Kenari')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    final allCenter = tester.getCenter(
      find.byKey(const Key('category-chip-Semua Lomba')),
    );
    final kenariCenter = tester.getCenter(
      find.byKey(const Key('category-chip-Kenari')),
    );
    final muraiCenter = tester.getCenter(
      find.byKey(const Key('category-chip-Murai Batu')),
    );
    expect(kenariCenter.dx, greaterThan(allCenter.dx));
    expect(kenariCenter.dx, lessThan(muraiCenter.dx));
  });

  testWidgets('memperbarui chip saat kategori backend berubah', (tester) async {
    _prepareView(tester);
    await tester.pumpWidget(
      const _ChipHost(categories: HomeDemoDataSource.categories),
    );
    await tester.pumpWidget(
      _ChipHost(categories: HomeDemoDataSource.categories.take(2).toList()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Murai Batu'), findsOneWidget);
    expect(find.text('Kacer'), findsNothing);
  });
}
