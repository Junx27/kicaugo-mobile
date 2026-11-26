import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:rumahkicau_mobile/core/widgets/glass_pill_bar.dart';
import 'package:rumahkicau_mobile/core/widgets/liquid_top_bar_icon_button.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/ticket_selection_item.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/pages/ticket_selection_page.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/ticket_selection_data.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    TicketSelectionItem? item,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(MaterialApp(home: TicketSelectionPage(item: item)));
    await tester.pumpAndSettle();
  }

  TicketSelectionItem itemWithPrice(String price) => TicketSelectionItem(
    id: 9,
    name: 'Kacer Ring',
    session: 'Sesi 02',
    time: '09:15 WIB',
    price: price,
  );

  Future<void> tapSeat(
    WidgetTester tester,
    String label, {
    bool warnIfMissed = true,
  }) async {
    await tester.scrollUntilVisible(
      find.text(label),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(label), warnIfMissed: warnIfMissed);
    await tester.pumpAndSettle();
  }

  testWidgets('tampil dengan pilihan awal VIP dan gantangan 18', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('Pilih Tiket & Nomor Gantangan'), findsNothing);
    expect(find.text(TicketSelectionStrings.topBarTitle), findsOneWidget);
    expect(find.text('Gantangan Terpilih: #G-18'), findsOneWidget);
    expect(find.text('Total Pembayaran (1 Tiket VIP)'), findsOneWidget);
    expect(find.text('Lanjut Bayar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('konten awal memiliki jarak dari top bar', (tester) async {
    await pumpPage(tester);

    final card = find
        .ancestor(
          of: find.text(TicketSelectionStrings.eventEdition.toUpperCase()),
          matching: find.byType(Container),
        )
        .first;
    final top = tester.getTopLeft(card).dy;

    expect(top, greaterThanOrEqualTo(kToolbarHeight - 12));
    expect(top, lessThan(kToolbarHeight + 4));
  });

  testWidgets('peta gantangan berjarak 8 dari kategori tiket', (tester) async {
    await pumpPage(tester);

    final tierCard = find
        .ancestor(
          of: find.text(TicketSelectionData.tiers.last.name),
          matching: find.byType(Container),
        )
        .first;
    final seatMapCard = find
        .ancestor(
          of: find.textContaining(TicketSelectionStrings.seatMapTitle),
          matching: find.byType(Container),
        )
        .first;

    final gap =
        tester.getTopLeft(seatMapCard).dy - tester.getBottomLeft(tierCard).dy;
    expect(gap, 8);
  });

  testWidgets('legenda dan grid gantangan berjarak 12', (tester) async {
    await pumpPage(tester);

    final grid = find.byType(GridView);
    final delegate =
        tester.widget<GridView>(grid).gridDelegate
            as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisSpacing, 4);
    expect(delegate.mainAxisSpacing, 4);

    final legendAndGrid = find.ancestor(
      of: grid,
      matching: find.byType(Column),
    );
    expect(tester.widget<Column>(legendAndGrid.first).spacing, 12);
  });

  testWidgets('harga kelas yang tidak cocok memakai tier default', (
    tester,
  ) async {
    await pumpPage(tester, item: itemWithPrice('Rp 999.000'));

    expect(find.text('Total Pembayaran (1 Tiket VIP)'), findsOneWidget);
  });

  testWidgets('harga kelas yang cocok jadi tier awal', (tester) async {
    await pumpPage(tester, item: itemWithPrice('Rp 150.000'));

    expect(find.text('Total Pembayaran (1 Tiket Umum)'), findsOneWidget);
  });

  testWidgets('memilih kategori tiket mengubah ringkasan dan total', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('Umum / Reguler'));
    await tester.pumpAndSettle();

    expect(find.text('Umum / Reguler (Dipilih 18)'), findsOneWidget);
    expect(find.text('Total Pembayaran (1 Tiket Umum)'), findsOneWidget);
  });

  testWidgets('memilih gantangan mengubah nomor di ringkasan dan total', (
    tester,
  ) async {
    await pumpPage(tester);

    await tapSeat(tester, '21');

    expect(find.text('Gantangan Terpilih: #G-21'), findsOneWidget);
    expect(find.text('• #G-21'), findsOneWidget);
  });

  testWidgets('gantangan yang terisi tidak dapat dipilih', (tester) async {
    await pumpPage(tester);

    await tapSeat(tester, '04', warnIfMissed: false);

    expect(find.text('Gantangan Terpilih: #G-18'), findsOneWidget);
  });

  testWidgets('top bar dan pill bawah tetap memakai kaca', (tester) async {
    await pumpPage(tester);

    expect(find.byType(LiquidTopBarIconButton), findsOneWidget);
    expect(find.byType(GlassPillBar), findsOneWidget);
    expect(find.bySemanticsLabel('Kembali'), findsOneWidget);
    expect(find.bySemanticsLabel('Tutup'), findsNothing);
    final glass = find.ancestor(
      of: find.text(TicketSelectionStrings.topBarTitle),
      matching: find.byType(LiquidGlass),
    );
    expect(glass, findsOneWidget);
    expect(
      find.descendant(
        of: glass,
        matching: find.byIcon(Icons.confirmation_number_rounded),
      ),
      findsOneWidget,
    );
    final size = tester.getSize(glass);
    expect(size.height, LiquidTopBarIconButton.size);
    expect(size.width, greaterThan(250));
  });

  testWidgets('tombol kaca atas dan checkout dapat ditekan', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.bySemanticsLabel('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjut Bayar'));
    await tester.pumpAndSettle();

    expect(find.byType(TicketSelectionPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  AnimatedSlide slideOf(WidgetTester tester) =>
      tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));

  testWidgets('bottom bar tampil saat halaman pertama dibuka', (tester) async {
    await pumpPage(tester);

    expect(find.text('Lanjut Bayar'), findsOneWidget);
    expect(slideOf(tester).offset, Offset.zero);
  });

  testWidgets('bottom bar tersembunyi saat scroll ke bawah', (tester) async {
    await pumpPage(tester);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    expect(slideOf(tester).offset, isNot(Offset.zero));
  });

  testWidgets('bottom bar muncul kembali saat scroll ke atas', (tester) async {
    await pumpPage(tester);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    expect(slideOf(tester).offset, isNot(Offset.zero));

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 200));
    await tester.pumpAndSettle();

    expect(slideOf(tester).offset, Offset.zero);
  });

  testWidgets('bottom bar tetap tampil saat scroll belum melewati ambang', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -10));
    await tester.pumpAndSettle();

    expect(slideOf(tester).offset, Offset.zero);
  });
}
