import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/router/app_routes.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/contest_detail_dto.dart';
import 'package:rumahkicau_mobile/features/event/data/datasources/fake_contest_detail_data_source.dart';
import 'package:rumahkicau_mobile/features/event/data/repositories/contest_detail_repository_impl.dart';
import 'package:rumahkicau_mobile/features/event/domain/entities/featured_contest.dart';
import 'package:rumahkicau_mobile/features/event/domain/usecases/get_contest_detail.dart';
import 'package:rumahkicau_mobile/features/event/presentation/contest_detail_strings.dart';
import 'package:rumahkicau_mobile/features/event/presentation/pages/contest_detail_page.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/ticket_selection_item.dart';
import 'package:rumahkicau_mobile/features/tickets/presentation/pages/ticket_selection_page.dart';

import '../../../../support/fake_image_http.dart';
import '../../support/contest_detail_fixture.dart';

void main() {
  void prepareView(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
  }

  Future<void> pumpPage(WidgetTester tester) async {
    prepareView(tester);
    await tester.pumpWidget(const MaterialApp(home: ContestDetailPage()));
    await tester.pumpAndSettle();
  }

  AnimatedSlide slideOf(WidgetTester tester) =>
      tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));

  int gradientCount(WidgetTester tester) => find
      .byWidgetPredicate((widget) {
        if (widget is! DecoratedBox) return false;
        final decoration = widget.decoration;
        return decoration is BoxDecoration && decoration.gradient != null;
      })
      .evaluate()
      .length;

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
    prepareView(tester);

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
    prepareView(tester);
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

  testWidgets('gagal memuat menampilkan pesan dan tombol coba lagi', (
    tester,
  ) async {
    prepareView(tester);
    final getContestDetail = GetContestDetail(
      ContestDetailRepositoryImpl(
        StubContestDetailDataSource(
          error: const DataFailure('Gagal memuat detail'),
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ContestDetailPage(id: 1, getContestDetail: getContestDetail),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gagal memuat detail'), findsOneWidget);
    await tester.tap(find.text(ContestDetailStrings.retry));
    await tester.pumpAndSettle();

    expect(find.text('Gagal memuat detail'), findsOneWidget);
  });

  testWidgets('tombol aksi top bar dapat diketuk', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.bySemanticsLabel('Bagikan'));
    await tester.tap(find.bySemanticsLabel('Simpan'));
    await tester.tap(find.bySemanticsLabel('Kembali'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('fallback gradient tampil saat aset hero gagal dimuat', (
    tester,
  ) async {
    prepareView(tester);
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: _FailingAssetBundle(),
        child: const MaterialApp(
          home: ContestDetailPage(detail: FakeContestDetailDataSource.content),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(gradientCount(tester), 3);
  });

  testWidgets('fallback gradient tampil saat gambar hero network gagal', (
    tester,
  ) async {
    debugNetworkImageHttpClientProvider = () =>
        FakeImageHttpClient(statusCode: HttpStatus.notFound);
    try {
      prepareView(tester);
      final detail = ContestDetailDto.fromJson(contestDetailPayload());
      await tester.pumpWidget(
        MaterialApp(home: ContestDetailPage(detail: detail)),
      );
      await tester.pumpAndSettle();

      expect(gradientCount(tester), 3);
    } finally {
      debugNetworkImageHttpClientProvider = null;
    }
  });

  testWidgets('tombol buka peta pada info lokasi dapat diketuk', (
    tester,
  ) async {
    await pumpPage(tester);

    final openMap = find.text(ContestDetailStrings.openMap);
    await tester.scrollUntilVisible(
      openMap,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 120));
    await tester.pumpAndSettle();
    await tester.tap(
      find.ancestor(of: openMap, matching: find.byType(TextButton)).first,
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

/// Asset bundle yang selalu gagal untuk menguji error builder gambar hero.
class _FailingAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    throw FlutterError('Aset tidak tersedia');
  }
}
