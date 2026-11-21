import '../../domain/entities/reminders_content.dart';
import 'reminders_data_source.dart';

/// Data demo; ganti dengan API saat backend siap.
class FakeRemindersDataSource implements RemindersDataSource {
  const FakeRemindersDataSource({
    this.delay = const Duration(milliseconds: 400),
  });

  final Duration delay;

  static const RemindersContent content = RemindersContent(
    birds: [
      ReminderBird(id: 'halilintar', name: 'Halilintar', species: 'Murai'),
      ReminderBird(
        id: 'black-phantom',
        name: 'Black Phantom',
        species: 'Kacer',
      ),
      ReminderBird(
        id: 'rawa-rontek',
        name: 'Rawa Rontek',
        species: 'Cucak Ijo',
      ),
    ],
    careReminders: [
      CareReminder(
        id: 'care-morning-sun',
        birdId: 'halilintar',
        time: '06:00',
        title: 'Embun Pagi & Jemur',
        detail: 'Halilintar (Murai Batu) • 30 menit matahari pagi',
        kind: CareKind.sunlight,
        isDone: true,
      ),
      CareReminder(
        id: 'care-morning-ef',
        birdId: 'halilintar',
        time: '07:30',
        title: 'EF Pagi',
        detail: 'Halilintar • 5 ekor jangkrik alam + 1 sdt kroto',
        kind: CareKind.feeding,
        isDone: true,
      ),
      CareReminder(
        id: 'care-evening-ef',
        birdId: 'rawa-rontek',
        time: '16:00',
        title: 'EF Sore & Masteran',
        detail: 'Rawa Rontek (Cucak Ijo) • Pisang kepok + 3 ulat hongkong',
        kind: CareKind.training,
      ),
      CareReminder(
        id: 'care-eve-grooming',
        birdId: 'halilintar',
        time: '20:00',
        title: 'Mandi Malam & Kerodong',
        detail: 'Halilintar • Mandi keramba 10 menit lalu full kerodong',
        kind: CareKind.grooming,
        contestEveOnly: true,
      ),
    ],
    contest: ContestAlarm(
      id: 'piala-raja-nusantara',
      title: 'Piala Raja Nusantara 2025',
      schedule: 'Minggu, 18 Mei • 09:00 WIB',
      venue: 'Batavia Arena',
      countdown: 'H-2 Hari',
      reminders: [
        ContestReminder(
          id: 'h1',
          title: 'Pengingat H-1 (Sabtu, 17 Mei • 18:00 WIB)',
          detail: 'Siapkan kerodong, kroto segar & cek ring',
        ),
        ContestReminder(
          id: 'h2',
          title: 'Alarm H-2 Jam (Minggu, 18 Mei • 07:00 WIB)',
          detail: 'Berangkat ke paddock & scan QR tiket',
        ),
      ],
    ),
    settings: ReminderSettings(
      ringtone: 'Suara Masteran Cililin HD',
      vibrationOn: true,
    ),
  );

  @override
  Future<RemindersContent> fetchReminders() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return content;
  }
}
