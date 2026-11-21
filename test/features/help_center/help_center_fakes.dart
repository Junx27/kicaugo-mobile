import 'dart:async';

import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/help_center/data/datasources/fake_help_center_data_source.dart';
import 'package:rumahkicau_mobile/features/help_center/data/repositories/help_center_repository_impl.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/entities/help_center_content.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/repositories/help_center_repository.dart';
import 'package:rumahkicau_mobile/features/help_center/domain/usecases/get_help_center_content.dart';

/// Pesan gagal yang dipakai repository palsu.
const String helpCenterFailure = 'Gagal memuat pusat bantuan';

/// Data Pusat Bantuan demo yang dipakai test widget dan cubit.
const HelpCenterContent sampleHelpCenter = FakeHelpCenterDataSource.content;

/// Usecase Pusat Bantuan dengan data demo tanpa jeda.
const GetHelpCenterContent instantHelpCenter = GetHelpCenterContent(
  HelpCenterRepositoryImpl(FakeHelpCenterDataSource(delay: Duration.zero)),
);

/// Repository Pusat Bantuan palsu dengan kegagalan yang bisa diatur.
class FakeHelpCenterRepository implements HelpCenterRepository {
  FakeHelpCenterRepository({
    this.content = sampleHelpCenter,
    this.delay = Duration.zero,
    this.failuresRemaining = 0,
  });

  final HelpCenterContent content;
  final Duration delay;
  int failuresRemaining;
  int fetchCalls = 0;

  @override
  Future<HelpCenterContent> fetchHelpCenterContent() async {
    fetchCalls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure(helpCenterFailure);
    }
    return content;
  }
}

/// Repository Pusat Bantuan yang menunggu [completer] untuk menguji loading.
class CompleterHelpCenterRepository implements HelpCenterRepository {
  CompleterHelpCenterRepository(this.completer);

  final Completer<HelpCenterContent> completer;

  @override
  Future<HelpCenterContent> fetchHelpCenterContent() => completer.future;
}
