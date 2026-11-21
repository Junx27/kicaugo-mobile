/// Teks statis halaman Pusat Bantuan.
abstract final class HelpCenterStrings {
  static const String title = 'Pusat Bantuan';
  static const String backTooltip = 'Kembali';
  static const String secure = 'Aman';

  static const String serviceEyebrow = 'Layanan Siaga 24/7';
  static const String heading = 'Pusat Bantuan & Panitia';
  static const String subtitle =
      'Kontak darurat EO lomba & respon cepat kicaumania se-Nusantara';

  static const String searchHint = 'Cari tiket, aturan gantangan, refund...';
  static const String searchFilterTooltip = 'Filter bantuan';

  static const String quickTitle = 'Bantuan Instan Kicaumania';
  static String quickCount(int count) => '$count Modul Aktif';
  static const String fieldReady = 'Siaga Lapangan';
  static String fieldHours(String hours) => 'Jam Tanggap Lapangan: $hours';

  static const String faqTitle = 'Kendala Sering Ditanyakan';
  static String faqTopicCount(int count) => '$count Topik Utama';
  static const String noResult =
      'Tidak ada kendala yang cocok dengan pencarian.';

  static const String supportTitle = 'Butuh Solusi Khusus?';
  static const String supportBody =
      'Hubungi hotline resmi 0812-KICAU-GO atau kirim berkas kendala tiket '
      'untuk investigasi prioritas tim pengawas PBI.';
  static const String createTicket = 'Buat Tiket Bantuan Digital';
  static const String archived = 'Tiket Terarsip';
  static const String escalation = 'Eskalasi ke Juri Utama';
}
