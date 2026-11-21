import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/community/domain/repositories/community_repository.dart';
import 'package:rumahkicau_mobile/features/community/domain/usecases/get_community_content.dart';
import 'package:rumahkicau_mobile/features/community/presentation/community_strings.dart';
import 'package:rumahkicau_mobile/features/community/presentation/pages/community_page.dart';
import 'package:rumahkicau_mobile/features/community/presentation/widgets/topic_chips.dart';

import '../../support/community_fakes.dart';

/// Memasang halaman di layar tinggi agar seluruh daftar ter-render.
Future<void> _pumpPage(
  WidgetTester tester, {
  GetCommunityContent? getContent,
  Size size = const Size(420, 3600),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: CommunityPage(
          getCommunityContent: getContent ?? _from(FakeCommunityRepository()),
        ),
      ),
    ),
  );
  await tester.pump();
}

GetCommunityContent _from(CommunityRepository repository) =>
    GetCommunityContent(repository);

Future<void> _tapTopic(WidgetTester tester, String label) async {
  await tester.dragUntilVisible(
    find.text(label),
    find.byType(TopicChips),
    const Offset(-120, 0),
  );
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pump(const Duration(milliseconds: 600));
  await tester.tap(find.text(label));
  await tester.pump();
}

/// Nilai opasitas FAB, dipakai untuk menguji visibilitas saat scroll.
double _createOpacity(WidgetTester tester) => tester
    .widget<AnimatedOpacity>(
      find.ancestor(
        of: find.byKey(const Key('community_create_post')),
        matching: find.byType(AnimatedOpacity),
      ),
    )
    .opacity;

void main() {
  testWidgets('loading lalu menampilkan seluruh bagian', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CommunityPage())),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Biarkan jeda data demo default selesai sebelum memasang ulang halaman.
    await tester.pump(const Duration(milliseconds: 500));

    await _pumpPage(tester);

    expect(find.text(CommunityStrings.clubTitle), findsOneWidget);
    expect(
      find.text('4.200 ${CommunityStrings.membersSuffix}'),
      findsOneWidget,
    );
    expect(find.text(sampleCommunity.trending.title), findsOneWidget);
    expect(find.text(sampleCommunity.poll.question), findsOneWidget);
    expect(find.text('62%'), findsOneWidget);
    expect(find.text(CommunityStrings.pollHint), findsOneWidget);
    for (final post in sampleCommunity.posts) {
      expect(find.text(post.author.name), findsOneWidget);
    }
    expect(find.text(CommunityStrings.champion), findsOneWidget);
    expect(find.byKey(const Key('community_create_post')), findsOneWidget);
    expect(find.byTooltip(CommunityStrings.createPost), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpPage(
      tester,
      getContent: _from(FakeCommunityRepository(failuresRemaining: 1)),
    );
    expect(find.text(communityFailure), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump();

    expect(find.text(CommunityStrings.clubTitle), findsOneWidget);
  });

  testWidgets('chip topik menyaring feed, Bursa kosong', (tester) async {
    await _pumpPage(tester);

    await _tapTopic(tester, 'Kacer & Cucak Ijo');
    expect(find.text('Rizky Hidayat'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsNothing);

    await _tapTopic(tester, 'Bursa Burung Juara');
    expect(find.text(CommunityStrings.emptyFeed), findsOneWidget);
  });

  testWidgets('gabung klub mengganti tombol dan jumlah anggota', (
    tester,
  ) async {
    await _pumpPage(tester);

    await tester.tap(find.text(CommunityStrings.join).first);
    await tester.pump();

    expect(find.text(CommunityStrings.joined), findsOneWidget);
    expect(
      find.text('4.201 ${CommunityStrings.membersSuffix}'),
      findsOneWidget,
    );
  });

  testWidgets('suka postingan menambah hitungan', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('124 ${CommunityStrings.likesSuffix}'));
    await tester.pump();

    expect(find.text('125 ${CommunityStrings.likesSuffix}'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
  });

  testWidgets('memilih polling menghitung ulang dan menandai pilihan', (
    tester,
  ) async {
    await _pumpPage(tester);

    await tester.tap(find.text(sampleCommunity.poll.options[2].label));
    await tester.pump();

    expect(find.text(CommunityStrings.pollSaved), findsOneWidget);
    expect(find.text('Total 1.421 votes'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets(
    'FAB hilang saat scroll ke bawah dan muncul saat scroll ke atas',
    (tester) async {
      await _pumpPage(tester, size: const Size(420, 800));
      final list = find.byWidgetPredicate(
        (widget) =>
            widget is ListView && widget.scrollDirection == Axis.vertical,
      );
      const settle = Duration(milliseconds: 300);

      expect(_createOpacity(tester), 1);

      await tester.drag(list, const Offset(0, -400));
      await tester.pump(settle);
      expect(_createOpacity(tester), 0);

      await tester.drag(list, const Offset(0, 300));
      await tester.pump(settle);
      expect(_createOpacity(tester), 1);

      await tester.drag(list, const Offset(0, -300));
      await tester.pump(settle);
      expect(_createOpacity(tester), 0);
    },
  );

  final comingSoon = <String, Finder Function()>{
    'kolom cari': () => find.text(CommunityStrings.searchHint),
    'lihat semua klub': () => find.text(CommunityStrings.seeAllClubs),
    'ikuti diskusi': () => find.text(CommunityStrings.followDiscussion),
    'filter feed': () => find.text(CommunityStrings.filter),
    'balasan': () => find.text('38 ${CommunityStrings.repliesSuffix}'),
    'bagikan': () => find.text(CommunityStrings.share).first,
    'menu lainnya': () => find.byTooltip(CommunityStrings.moreTooltip).first,
    'buat postingan': () => find.byKey(const Key('community_create_post')),
  };
  comingSoon.forEach((name, finder) {
    testWidgets('$name menampilkan segera hadir', (tester) async {
      await _pumpPage(tester);

      await tester.tap(finder());
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  });
}
