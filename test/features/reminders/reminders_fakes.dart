import 'dart:async';

import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/reminders/data/datasources/fake_reminders_data_source.dart';
import 'package:rumahkicau_mobile/features/reminders/data/repositories/reminders_repository_impl.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/entities/reminders_content.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/repositories/reminders_repository.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/usecases/get_reminders_content.dart';

/// Pesan gagal yang dipakai repository palsu.
const String remindersFailure = 'Gagal memuat pengingat';

/// Data pengingat demo yang dipakai test widget dan cubit.
const RemindersContent sampleReminders = FakeRemindersDataSource.content;

/// Usecase pengingat dengan data demo tanpa jeda.
const GetRemindersContent instantReminders = GetRemindersContent(
  RemindersRepositoryImpl(FakeRemindersDataSource(delay: Duration.zero)),
);

/// Repository pengingat palsu dengan kegagalan yang bisa diatur.
class FakeRemindersRepository implements RemindersRepository {
  FakeRemindersRepository({
    this.content = sampleReminders,
    this.delay = Duration.zero,
    this.failuresRemaining = 0,
  });

  final RemindersContent content;
  final Duration delay;
  int failuresRemaining;
  int fetchCalls = 0;

  @override
  Future<RemindersContent> fetchReminders() async {
    fetchCalls++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const DataFailure(remindersFailure);
    }
    return content;
  }
}

/// Repository pengingat yang menunggu [completer] untuk menguji loading.
class CompleterRemindersRepository implements RemindersRepository {
  CompleterRemindersRepository(this.completer);

  final Completer<RemindersContent> completer;

  @override
  Future<RemindersContent> fetchReminders() => completer.future;
}
