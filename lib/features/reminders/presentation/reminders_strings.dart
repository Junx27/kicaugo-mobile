/// Teks statis halaman pengingat.
abstract final class RemindersStrings {
  static const String title = 'Pengingat Rawatan & Alarm Lomba';
  static const String backTooltip = 'Kembali';
  static const String addTooltip = 'Tambah pengingat';
  static const String settingsTooltip = 'Pengaturan pengingat';

  static const String intro =
      'Atur jadwal harian & alarm gantangan agar gacoan selalu top form.';
  static const String allBirds = 'Semua Gacoan';

  static const String contestActive = 'ALARM LOMBA AKTIF';
  static const String addAlarm = 'Tambah Alarm Event Lain';
  static const String contestEve = 'Khusus H-1';

  static const String careToday = 'Jadwal Rawatan Hari Ini';
  static const String emptyCare = 'Belum ada rawatan untuk gacoan ini.';
  static String progress(int done, int total) => '$done/$total Selesai';

  static const String ringtoneTitle = 'Nada Dering Alarm';
  static const String play = 'Putar';
  static const String vibrationTitle = 'Mode Getar Paddock';
  static const String vibrationDetail = 'Getar kuat saat di area lomba';

  static const String createCare = 'Buat Pengingat Rawatan Baru';
  static const String doneTooltip = 'Tandai selesai';
  static String careTime(String time, String title) => '$time WIB • $title';
}
