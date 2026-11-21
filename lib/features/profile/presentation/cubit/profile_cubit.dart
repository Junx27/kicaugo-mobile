import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_profile_content.dart';
import 'profile_state.dart';

/// Memuat konten halaman Profil.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfileContent) : super(const ProfileState());

  final GetProfileContent _getProfileContent;

  Future<void> load() async {
    emit(const ProfileState(status: ProfileStatus.loading));
    try {
      final content = await _getProfileContent();
      emit(ProfileState(status: ProfileStatus.success, content: content));
    } on Failure catch (failure) {
      emit(
        ProfileState(status: ProfileStatus.failure, message: failure.message),
      );
    }
  }
}
