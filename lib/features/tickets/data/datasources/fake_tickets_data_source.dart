import '../../../../core/entities/bird_category.dart';
import '../../domain/entities/past_ticket.dart';
import '../../domain/entities/ticket_parts.dart';
import '../../domain/entities/ticket_stat.dart';
import '../../domain/entities/tickets_content.dart';
import '../../domain/entities/upcoming_ticket.dart';
import 'tickets_data_source.dart';

/// Sumber data dummy untuk Tiket Saya.
///
/// DATA DEMO: nama acara, arena, burung, nomor ring, dan hasil lomba di sini
/// fiktif dan tidak mewakili organisasi atau penjurian nyata.
class FakeTicketsDataSource implements TicketsDataSource {
  const FakeTicketsDataSource({this.delay = const Duration(milliseconds: 400)});

  final Duration delay;

  static const String _judges = 'Juri Panitia';

  static const TicketsContent content = TicketsContent(
    upcoming: <UpcomingTicket>[
      UpcomingTicket(
        code: 'KCG-2026-MRB-081928',
        countdown: 'H-1',
        category: BirdCategory.muraiBatu,
        event: TicketEvent(
          title: 'Piala Raja Nusantara 2026',
          series: 'Kicau Master Series',
          schedule: 'Sabtu, 21 Nov 2026 • Pukul 10:30 WIB',
          className: 'Kelas: Murai Batu Utama (Tiket G-24)',
          venue: 'Batavia Arena Gantangan',
          address: 'Jl. Daan Mogot KM 12, Paddock 3, Jakarta Barat',
          latitude: -6.150000,
          longitude: 106.750000,
        ),
        seat: TicketSeat(
          number: '#G-18',
          label: 'VIP Depan Juri',
          position: 'Blok Barat • Baris Ring 1',
          session: '04',
        ),
        bird: TicketBird(
          name: 'Halilintar',
          breed: 'Murai Batu Medan',
          ring: 'Ring KG-2026-8891',
          owner: 'Pemilik: Kicau Mania (Batavia SF)',
        ),
      ),
      UpcomingTicket(
        code: 'KCG-2026-KCR-090514',
        countdown: 'H-8',
        category: BirdCategory.kacer,
        event: TicketEvent(
          title: 'Piala Angkasa Cup IV 2026',
          series: 'Liga Kicau Jabodetabek',
          schedule: 'Sabtu, 28 Nov 2026 • Sesi 02 (09:00 WIB)',
          className: 'Kelas: Kacer Master Standar B',
          venue: 'Arena Angkasa Halim',
          address: 'Jl. Angkasa Raya 8, Jakarta Timur',
          latitude: -6.200000,
          longitude: 106.880000,
        ),
        seat: TicketSeat(
          number: '#G-09',
          label: 'Reguler',
          position: 'Blok Timur • Baris Ring 2',
          session: '02',
        ),
        bird: TicketBird(
          name: 'Black Phantom',
          breed: 'Kacer Jabar',
          ring: 'Ring KG-2026-4417',
          owner: 'Pemilik: Kicau Mania (Batavia SF)',
        ),
      ),
    ],
    history: <PastTicket>[
      PastTicket(
        title: 'Liga Batavia Kicau Seri II',
        detail: '7 November 2026 • Gantangan #24',
        className: 'Murai Batu BOB (Best of Best) • $_judges',
        category: BirdCategory.muraiBatu,
        result: (
          label: 'Juara 2 (Perak)',
          score: 'Skor Koncer: A1, B2 (Total: 840)',
        ),
      ),
      PastTicket(
        title: 'Latber Kacer Mingguan Seri V',
        detail: '31 Oktober 2026 • Gantangan #12',
        className: 'Kacer Standar A • $_judges',
        category: BirdCategory.kacer,
        result: (
          label: 'Juara 1 (Emas)',
          score: 'Skor Koncer: A1, A1 (Total: 910)',
        ),
      ),
      PastTicket(
        title: 'Festival Cucak Hijau Jakarta',
        detail: '24 Oktober 2026 • Gantangan #07',
        className: 'Cucak Hijau Utama • $_judges',
        category: BirdCategory.cucakHijau,
        result: (
          label: 'Juara 3 (Perunggu)',
          score: 'Skor Koncer: B1, B2 (Total: 790)',
        ),
      ),
      PastTicket(
        title: 'Latpres Murai Batu Kemang',
        detail: '17 Oktober 2026 • Gantangan #31',
        className: 'Murai Batu Standar',
        category: BirdCategory.muraiBatu,
        result: (label: 'Peserta', score: 'Skor Koncer: C1 (Total: 640)'),
      ),
      PastTicket(
        title: 'Kenari Cup Pesanggrahan',
        detail: '10 Oktober 2026 • Gantangan #05',
        className: 'Kenari Utama',
        category: BirdCategory.kenari,
        result: (label: 'Peserta', score: 'Skor Koncer: B3 (Total: 700)'),
      ),
    ],
    cancelled: <PastTicket>[
      PastTicket(
        title: 'Latber Cucak Ijo Malam',
        detail: '14 November 2026 • Gantangan #15',
        className: 'Cucak Hijau Standar • Dana dikembalikan',
        category: BirdCategory.cucakHijau,
      ),
    ],
    stats: (
      podium: TicketStat(
        headline: '3 Podium',
        label: 'Musim 2026',
        note: 'Juara 1, 2 & 3 regional Batavia',
      ),
      ring: TicketStat(
        headline: 'Ring Digital',
        label: 'Terverifikasi',
        note: 'ID digital tersimpan aman untuk semua lomba',
      ),
    ),
  );

  @override
  Future<TicketsContent> fetchTickets() async {
    await Future<void>.delayed(delay);
    return content;
  }
}
