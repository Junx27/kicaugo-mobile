import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/usecases/get_help_center_content.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/cubit/help_center_cubit.dart';
import 'package:rumahkicau_mobile/features/help_center/presentation/cubit/help_center_state.dart';

import '../../help_center_fakes.dart';

void main() {
  HelpCenterCubit buildCubit([FakeHelpCenterRepository? repository]) =>
      HelpCenterCubit(
        GetHelpCenterContent(repository ?? FakeHelpCenterRepository()),
      );

  blocTest<HelpCenterCubit, HelpCenterState>(
    'memuat konten lalu success',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => const [
      HelpCenterState(status: HelpCenterStatus.loading),
      HelpCenterState(
        status: HelpCenterStatus.success,
        content: sampleHelpCenter,
      ),
    ],
  );

  blocTest<HelpCenterCubit, HelpCenterState>(
    'gagal memuat menyimpan pesan',
    build: () => buildCubit(FakeHelpCenterRepository(failuresRemaining: 1)),
    act: (cubit) => cubit.load(),
    expect: () => const [
      HelpCenterState(status: HelpCenterStatus.loading),
      HelpCenterState(
        status: HelpCenterStatus.failure,
        message: helpCenterFailure,
      ),
    ],
  );

  test('state tanpa konten tidak memiliki FAQ', () {
    expect(const HelpCenterState().visibleFaqs, isEmpty);
  });

  test('pencarian memfilter pertanyaan dan jawaban', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    expect(cubit.state.visibleFaqs, hasLength(4));

    cubit.search('offline');
    expect(cubit.state.visibleFaqs.single.id, 'offline');

    cubit.search('KUOTA');
    expect(cubit.state.visibleFaqs.single.id, 'offline');

    cubit.search('  scan tiket  ');
    expect(cubit.state.visibleFaqs.single.id, 'offline');

    cubit.search('tidak-ada');
    expect(cubit.state.visibleFaqs, isEmpty);

    cubit.search('');
    expect(cubit.state.visibleFaqs, hasLength(4));
  });

  test('toggle FAQ membuka satu, berpindah, lalu menutup', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    cubit.toggleFaq('gantangan');
    expect(cubit.state.expandedFaqId, 'gantangan');

    cubit.toggleFaq('offline');
    expect(cubit.state.expandedFaqId, 'offline');

    cubit.toggleFaq('offline');
    expect(cubit.state.expandedFaqId, isNull);
  });

  test('pencarian baru menutup FAQ yang sedang terbuka', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);
    await cubit.load();

    cubit.toggleFaq('gantangan');
    cubit.search('offline');

    expect(cubit.state.expandedFaqId, isNull);
    expect(cubit.state.visibleFaqs.single.id, 'offline');
  });
}
