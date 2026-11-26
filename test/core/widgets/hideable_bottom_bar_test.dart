import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/widgets/hideable_bottom_bar.dart';

void main() {
  AnimatedSlide slideOf(WidgetTester tester) =>
      tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));

  Future<void> pumpBar(
    WidgetTester tester, {
    ScrollController? controller,
  }) async {
    final scrollController = controller ?? ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: 100,
                itemBuilder: (_, index) =>
                    SizedBox(height: 80, child: Text('Item $index')),
              ),
              HideableBottomBar(
                controller: scrollController,
                child: const Text('Lanjut Bayar'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('kembali ke posisi awal mereset arah dan menampilkan bar', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpBar(tester, controller: controller);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(slideOf(tester).offset, isNot(Offset.zero));

    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(slideOf(tester).offset, Offset.zero);
  });

  testWidgets('perubahan arah gulir mereset akumulator', (tester) async {
    await pumpBar(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(slideOf(tester).offset, isNot(Offset.zero));

    await tester.drag(find.byType(ListView), const Offset(0, 5));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -5));
    await tester.pumpAndSettle();

    expect(slideOf(tester).offset, isNot(Offset.zero));
  });

  testWidgets('controller baru menggantikan listener lama', (tester) async {
    await tester.pumpWidget(const _SwapHost());
    await tester.pumpAndSettle();

    final state = tester.state<_SwapHostState>(find.byType(_SwapHost));
    state.swapController();
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

class _SwapHost extends StatefulWidget {
  const _SwapHost();

  @override
  State<_SwapHost> createState() => _SwapHostState();
}

class _SwapHostState extends State<_SwapHost> {
  final ScrollController first = ScrollController();
  final ScrollController second = ScrollController();
  bool _swapped = false;

  void swapController() => setState(() => _swapped = true);

  @override
  void dispose() {
    first.dispose();
    second.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            HideableBottomBar(
              controller: _swapped ? second : first,
              child: const Text('Lanjut Bayar'),
            ),
          ],
        ),
      ),
    );
  }
}
