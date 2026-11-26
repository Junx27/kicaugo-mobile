import 'package:flutter/material.dart';

/// Satu tingkatan tiket pada halaman pemesanan (data dummy sementara).
class TicketTier {
  const TicketTier({
    required this.name,
    required this.price,
    required this.location,
    required this.badge,
    required this.icon,
    required this.priceLabel,
    this.perks = const <String>[],
  });

  final String name;
  final String price;
  final String location;
  final String badge;
  final IconData icon;
  final String priceLabel;
  final List<String> perks;

  /// Nama pendek untuk ringkasan total pembayaran, mis. "VIP".
  String get shortName => name.split(' ').first;
}

/// Teks dan konfigurasi dummy halaman "Pilih Tiket & Nomor Gantangan".
abstract final class TicketSelectionStrings {
  static const String back = 'Kembali';
  static const String topBarTitle = 'Pilih Tiket & nomor gantangan';
  static const String eventEdition = 'Piala Raja Nusantara 2025';
  static const String chooseCategoryTitle = 'Pilih Kategori Tiket';
  static const String chooseCategorySubtitle =
      'Pilih tingkatan kelas untuk menentukan posisi arena';
  static const String categoryCount = 'Kategori';
  static const String available = 'Tersedia';
  static const String favorite = 'Favorit';
  static const String selected = 'Terpilih';
  static const String ticketCost = 'Biaya Tiket';
  static const String vipTicketCost = 'Biaya Tiket VIP';
  static const String perkDistance = 'Jarak Pantau 3 Meter';
  static const String perkId = 'ID Pass Eksklusif';
  static const String seatMapTitle = 'Peta Nomor Gantangan';
  static const String seatMapFormat = '36G';
  static const String gridLabel = '6 × 6 Grid';
  static const String seatMapSubtitle = 'Format 36 Tiang • Arena Batavia Utama';
  static const String stageLabel = 'Meja Dewan Juri & Pengawas';
  static const String legendSelected = 'Dipilih';
  static const String legendBooked = 'Terisi';
  static const String zoneA = 'Baris 1-2: Zona A (Juri)';
  static const String zoneB = 'Baris 3-4: Zona B (Tengah)';
  static const String zoneC = 'Baris 5-6: Zona C (Luar)';
  static const String selectionTitle = 'Detail Pilihan Tiket';
  static const String selectedSeatPrefix = 'Gantangan Terpilih: #G-';
  static const String locked = 'Terkunci (10m)';
  static const String scheduleLabel = 'Jadwal Sesi';
  static const String cageLabel = 'Spesifikasi Sangkar';
  static const String cageValue = 'Standar No. 1';
  static const String rulesTitle = 'Aturan Penjurian & Tiket';
  static const String rulesBody =
      'Nomor tiang gantangan tidak dapat ditukar setelah pembayaran terverifikasi. '
      'Harap hadir di paddock 30 menit sebelum sesi dimulai untuk verifikasi '
      'segel sangkar.';
  static const String totalLabel = 'Total Pembayaran (1 Tiket ';
  static const String checkout = 'Lanjut Bayar';
  static const String seatPrefix = '#G-';
}

/// Isi dummy halaman pemesanan tiket dan gantangan.
abstract final class TicketSelectionData {
  static const List<TicketTier> tiers = <TicketTier>[
    TicketTier(
      name: 'Umum / Reguler',
      price: 'Rp 150.000',
      location: 'Sisi Tribun Luar B',
      badge: TicketSelectionStrings.available,
      icon: Icons.airplane_ticket_rounded,
      priceLabel: TicketSelectionStrings.ticketCost,
    ),
    TicketTier(
      name: 'Peserta Standar',
      price: 'Rp 250.000',
      location: 'Zona Tengah Ring 2',
      badge: TicketSelectionStrings.favorite,
      icon: Icons.verified_rounded,
      priceLabel: TicketSelectionStrings.ticketCost,
    ),
    TicketTier(
      name: 'VIP Eksklusif',
      price: 'Rp 500.000',
      location: 'Sisi Depan Juri + Paddock Akses',
      badge: TicketSelectionStrings.selected,
      icon: Icons.workspace_premium_rounded,
      priceLabel: TicketSelectionStrings.vipTicketCost,
      perks: <String>[
        TicketSelectionStrings.perkDistance,
        TicketSelectionStrings.perkId,
      ],
    ),
  ];

  /// VIP menjadi pilihan awal bila harga kelas tidak cocok dengan tier mana pun.
  static const int defaultTierIndex = 2;
  static const String defaultSeat = '18';
  static const int gridCount = 6;
  static const int seatCount = 36;
  static const Set<int> bookedSeats = <int>{4, 7, 12, 15, 22, 28, 31};

  static String formatSeat(int number) => number.toString().padLeft(2, '0');
}
