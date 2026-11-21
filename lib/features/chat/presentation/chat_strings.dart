/// Teks statis halaman Pesan.
abstract final class ChatStrings {
  static const String title = 'Pesan';
  static const String searchHint = 'Cari sesi chat panitia atau komunitas...';
  static const String filterAll = 'Semua';
  static const String filterOrganizer = 'Panitia EO';
  static const String filterCommunity = 'Komunitas';
  static const String badgeOrganizer = 'Panitia EO';
  static const String badgeCommunity = 'Komunitas';
  static const String badgeSupport = 'CS Panitia';
  static const String online = 'Online';
  static const String verifiedTooltip = 'Panitia terverifikasi';
  static const String composeTooltip = 'Tulis pesan baru';
  static const String emptyTitle = 'Percakapan tidak ditemukan';
  static const String emptyHint =
      'Coba kata kunci lain atau pilih filter Semua.';

  static String newMessages(int count) => '$count baru';
}
