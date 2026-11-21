import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/onboarding/presentation/cubit/onboarding_cubit.dart';

OnboardingCubit _build() => OnboardingCubit(slideCount: 3);

void main() {
  test('mulai dari slide pertama dan belum terakhir', () {
    final cubit = _build();
    addTearDown(cubit.close);

    expect(cubit.state, 0);
    expect(cubit.isLast, isFalse);
  });

  blocTest<OnboardingCubit, int>(
    'select memancarkan indeks yang dipilih',
    build: _build,
    act: (cubit) => cubit.select(2),
    expect: () => [2],
    verify: (cubit) => expect(cubit.isLast, isTrue),
  );

  blocTest<OnboardingCubit, int>(
    'next maju satu slide',
    build: _build,
    act: (cubit) => cubit.next(),
    expect: () => [1],
  );

  blocTest<OnboardingCubit, int>(
    'next di slide terakhir tidak memancarkan apa pun',
    build: _build,
    seed: () => 2,
    act: (cubit) => cubit.next(),
    expect: () => <int>[],
  );
}
