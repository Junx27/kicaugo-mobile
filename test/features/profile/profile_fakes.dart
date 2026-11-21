import 'dart:async';

import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/profile/data/datasources/fake_profile_data_source.dart';
import 'package:rumahkicau_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:rumahkicau_mobile/features/profile/domain/entities/profile_content.dart';
import 'package:rumahkicau_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/get_profile_content.dart';

/// Pesan gagal yang dipakai repository palsu.
const String profileFailure = 'Gagal memuat profil';

/// Data profil demo yang dipakai test widget dan cubit.
const ProfileContent sampleProfile = FakeProfileDataSource.content;

/// Usecase profil dengan data demo tanpa jeda.
const GetProfileContent instantProfile = GetProfileContent(
  ProfileRepositoryImpl(FakeProfileDataSource(delay: Duration.zero)),
);

/// Repository profil palsu dengan kegagalan yang bisa diatur.
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({
    this.content = sampleProfile,
    this.delay = Duration.zero,
    this.failuresRemaining = 0,
  });

  final ProfileContent content;
  final Duration delay;
  int failuresRemaining;
  int fetchCalls = 0;

  @override
  Future<ProfileContent> fetchProfileContent() async {
    fetchCalls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure(profileFailure);
    }
    return content;
  }
}

/// Repository profil yang menunggu [completer] untuk menguji state loading.
class CompleterProfileRepository implements ProfileRepository {
  CompleterProfileRepository(this.completer);

  final Completer<ProfileContent> completer;

  @override
  Future<ProfileContent> fetchProfileContent() => completer.future;
}
