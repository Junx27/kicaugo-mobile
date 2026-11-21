import 'package:bloc_test/bloc_test.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/get_profile_content.dart';
import 'package:rumahkicau_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:rumahkicau_mobile/features/profile/presentation/cubit/profile_state.dart';

import '../../profile_fakes.dart';

void main() {
  ProfileCubit buildCubit([FakeProfileRepository? repository]) =>
      ProfileCubit(GetProfileContent(repository ?? FakeProfileRepository()));

  blocTest<ProfileCubit, ProfileState>(
    'memuat konten lalu success',
    build: buildCubit,
    act: (cubit) => cubit.load(),
    expect: () => const [
      ProfileState(status: ProfileStatus.loading),
      ProfileState(status: ProfileStatus.success, content: sampleProfile),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'gagal memuat menyimpan pesan',
    build: () => buildCubit(FakeProfileRepository(failuresRemaining: 1)),
    act: (cubit) => cubit.load(),
    expect: () => const [
      ProfileState(status: ProfileStatus.loading),
      ProfileState(status: ProfileStatus.failure, message: profileFailure),
    ],
  );
}
