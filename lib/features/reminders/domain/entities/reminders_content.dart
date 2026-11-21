import 'package:equatable/equatable.dart';

/// Burung yang punya jadwal rawatan.
class ReminderBird extends Equatable {
  const ReminderBird({
    required this.id,
    required this.name,
    required this.species,
  });

  final String id;
  final String name;
  final String species;

  /// Label pill, mis. "Halilintar (Murai)".
  String get filterLabel => '$name ($species)';

  @override
  List<Object?> get props => [id, name, species];
}

/// Jenis rawatan; ikonnya dipetakan di presentation, bukan di domain.
enum CareKind { sunlight, feeding, training, grooming }

/// Satu kartu rawatan harian.
class CareReminder extends Equatable {
  const CareReminder({
    required this.id,
    required this.birdId,
    required this.time,
    required this.title,
    required this.detail,
    required this.kind,
    this.isDone = false,
    this.alarmOn = true,
    this.contestEveOnly = false,
  });

  final String id;
  final String birdId;
  final String time;
  final String title;
  final String detail;
  final CareKind kind;
  final bool isDone;
  final bool alarmOn;
  final bool contestEveOnly;

  CareReminder copyWith({bool? isDone, bool? alarmOn}) {
    return CareReminder(
      id: id,
      birdId: birdId,
      time: time,
      title: title,
      detail: detail,
      kind: kind,
      isDone: isDone ?? this.isDone,
      alarmOn: alarmOn ?? this.alarmOn,
      contestEveOnly: contestEveOnly,
    );
  }

  @override
  List<Object?> get props => [
    id,
    birdId,
    time,
    title,
    detail,
    kind,
    isDone,
    alarmOn,
    contestEveOnly,
  ];
}

/// Satu baris pengingat di dalam alarm lomba (H-1, H-2 jam).
class ContestReminder extends Equatable {
  const ContestReminder({
    required this.id,
    required this.title,
    required this.detail,
    this.isOn = true,
  });

  final String id;
  final String title;
  final String detail;
  final bool isOn;

  ContestReminder copyWith({bool? isOn}) {
    return ContestReminder(
      id: id,
      title: title,
      detail: detail,
      isOn: isOn ?? this.isOn,
    );
  }

  @override
  List<Object?> get props => [id, title, detail, isOn];
}

/// Alarm lomba terdekat.
class ContestAlarm extends Equatable {
  const ContestAlarm({
    required this.id,
    required this.title,
    required this.schedule,
    required this.venue,
    required this.countdown,
    required this.reminders,
  });

  final String id;
  final String title;
  final String schedule;
  final String venue;
  final String countdown;
  final List<ContestReminder> reminders;

  ContestAlarm copyWith({List<ContestReminder>? reminders}) {
    return ContestAlarm(
      id: id,
      title: title,
      schedule: schedule,
      venue: venue,
      countdown: countdown,
      reminders: reminders ?? this.reminders,
    );
  }

  @override
  List<Object?> get props => [id, title, schedule, venue, countdown, reminders];
}

/// Preferensi suara dan getar alarm.
class ReminderSettings extends Equatable {
  const ReminderSettings({required this.ringtone, required this.vibrationOn});

  final String ringtone;
  final bool vibrationOn;

  ReminderSettings copyWith({bool? vibrationOn}) {
    return ReminderSettings(
      ringtone: ringtone,
      vibrationOn: vibrationOn ?? this.vibrationOn,
    );
  }

  @override
  List<Object?> get props => [ringtone, vibrationOn];
}

/// Seluruh data halaman pengingat.
class RemindersContent extends Equatable {
  const RemindersContent({
    required this.birds,
    required this.careReminders,
    required this.contest,
    required this.settings,
  });

  final List<ReminderBird> birds;
  final List<CareReminder> careReminders;
  final ContestAlarm contest;
  final ReminderSettings settings;

  RemindersContent copyWith({
    List<CareReminder>? careReminders,
    ContestAlarm? contest,
    ReminderSettings? settings,
  }) {
    return RemindersContent(
      birds: birds,
      careReminders: careReminders ?? this.careReminders,
      contest: contest ?? this.contest,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [birds, careReminders, contest, settings];
}
