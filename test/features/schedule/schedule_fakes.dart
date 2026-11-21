import 'dart:async';

import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/schedule/data/datasources/fake_schedule_data_source.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/schedule_content.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/repositories/schedule_repository.dart';

/// Konten Jadwal demo yang dipakai test.
final ScheduleContent sampleSchedule = FakeScheduleDataSource.content;

/// Repository Jadwal palsu dengan kegagalan yang bisa diatur.
class FakeScheduleRepository implements ScheduleRepository {
  FakeScheduleRepository({this.failuresRemaining = 0});

  int failuresRemaining;
  int calls = 0;

  @override
  Future<ScheduleContent> fetchScheduleContent() async {
    calls++;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure('Gagal memuat jadwal');
    }
    return sampleSchedule;
  }
}

/// Repository yang menunggu [completer] untuk menguji state loading.
class CompleterScheduleRepository implements ScheduleRepository {
  CompleterScheduleRepository(this.completer);

  final Completer<ScheduleContent> completer;

  @override
  Future<ScheduleContent> fetchScheduleContent() => completer.future;
}
