import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/features/event/domain/entities/featured_contest.dart';
import 'package:rumahkicau_mobile/features/event/presentation/pages/contest_detail_page.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/ticket_selection_item.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/pages/ticket_selection_page.dart';

void main() {
  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const MaterialApp(home: ContestDetailPage()));
    await tester.pumpAndSettle();
  }

  AnimatedSlide slideOf(WidgetTester tester) =>
      tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));

  testWidgets('bottom bar tampil saat halaman pertama dibuka', (tester) async {
    await pumpPage(tester);

    expect(find.text('Beli Tiket'), findsOneWidget);
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

  testWidgets('bottom bar tetap tampil saat konten belum melewati ambang', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -10));
    await tester.pumpAndSettle();

    expect(slideOf(tester).offset, Offset.zero);
  });

  testWidgets('banner hero selebar layar dan menyentuh tepi atas', (
    tester,
  ) async {
    await pumpPage(tester);

    final hero = find.byType(Image).first;
    expect(tester.getRect(hero), const Rect.fromLTWH(0, 0, 360, 320));
    expect(
      tester.getTopLeft(find.text('Resmi PBI & BnR')).dy,
      greaterThan(tester.getBottomRight(hero).dy),
    );
  });

  testWidgets('konten dummy menampilkan kelas dan aturan lomba', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('Murai Batu Utama - Raja Batavia'), findsOneWidget);
    expect(find.text('Aturan Sangkar'), findsOneWidget);
  });

  testWidgets('detail dari kartu beranda memakai dummy konten lengkap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    const contest = FeaturedContest(
      title: 'Lomba Kicau Desa',
      schedule: 'Sabtu, 6 Des • Jakarta',
      distance: '3 km',
      prize: 'Rp 10.000.000',
      slots: '10 slot',
      attendees: (initials: ['A'], others: 1),
    );
    await tester.pumpWidget(
      const MaterialApp(home: ContestDetailPage(contest: contest)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lomba Kicau Desa'), findsOneWidget);
    expect(find.text('Murai Batu Utama - Raja Batavia'), findsOneWidget);
    expect(find.text('Aturan Sangkar'), findsOneWidget);
  });

  Future<void> pumpRoutedPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ContestDetailPage(),
        ),
        GoRoute(
          path: AppRoutes.ticketSelection,
          builder: (context, state) => TicketSelectionPage(
            item: state.extra is TicketSelectionItem
                ? state.extra as TicketSelectionItem
                : null,
          ),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  testWidgets('kartu kelas membuka halaman pilih tiket', (tester) async {
    await pumpRoutedPage(tester);

    final card = find.text('Murai Batu Utama - Raja Batavia');
    await tester.scrollUntilVisible(
      card,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 120));
    await tester.pumpAndSettle();
    await tester.tap(
      find.ancestor(of: card, matching: find.byType(InkWell)).first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(TicketSelectionPage), findsOneWidget);
    expect(
      find.text('Murai Batu Utama - Raja Batavia • Sesi 04'),
      findsOneWidget,
    );
  });

  testWidgets('tombol Beli Tiket membuka halaman pilih tiket', (tester) async {
    await pumpRoutedPage(tester);

    await tester.tap(find.text('Beli Tiket'));
    await tester.pumpAndSettle();

    expect(find.byType(TicketSelectionPage), findsOneWidget);
  });
}
