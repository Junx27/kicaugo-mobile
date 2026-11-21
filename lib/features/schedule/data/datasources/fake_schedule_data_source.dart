import '../../../../core/entities/bird_category.dart';
import '../../domain/entities/agenda.dart';
import '../../domain/entities/calendar_day.dart';
import '../../domain/entities/featured_event.dart';
import '../../domain/entities/schedule_content.dart';
import '../../domain/entities/schedule_region.dart';
import 'schedule_data_source.dart';

/// Sumber data dummy untuk Jadwal.
///
/// DATA DEMO: nama event, penyelenggara, angka kuota, hadiah, dan klaim di
/// sini fiktif dan wajib diganti data resmi sebelum rilis. Minggu yang
/// ditampilkan adalah Senin 16 – Minggu 22 Nov 2026.
class FakeScheduleDataSource implements ScheduleDataSource {
  const FakeScheduleDataSource({
    this.delay = const Duration(milliseconds: 400),
  });

  final Duration delay;

  static final DateTime _peak = DateTime(2026, 11, 22);

  static final ScheduleContent content = ScheduleContent(
    summary: const ScheduleSummary(
      location: 'Jabodetabek',
      nearbyArenas: 12,
      monthLabel: 'Nov 2026',
      weekLabel: 'Minggu ke-3',
      mapDistance: '2.4 km',
    ),
    regions: const <RegionCount>[
      (region: ScheduleRegion.jabodetabek, arenas: 12),
      (region: ScheduleRegion.jawaBarat, arenas: 8),
      (region: ScheduleRegion.jawaTengah, arenas: 14),
      (region: ScheduleRegion.jawaTimur, arenas: 19),
    ],
    days: <CalendarDay>[
      CalendarDay(date: DateTime(2026, 11, 16), label: '-'),
      CalendarDay(date: DateTime(2026, 11, 17), label: '1 Event'),
      CalendarDay(date: DateTime(2026, 11, 18), label: '-'),
      CalendarDay(
        date: DateTime(2026, 11, 19),
        label: '2 Latber',
        accent: AgendaAccent.yellow,
      ),
      CalendarDay(
        date: DateTime(2026, 11, 20),
        label: '3 Event',
        accent: AgendaAccent.lime,
      ),
      CalendarDay(date: DateTime(2026, 11, 21), label: '4 Event'),
      CalendarDay(date: _peak, label: '5 Event', isPeak: true),
    ],
    featured: FeaturedEvent(
      headline: (
        title: 'Piala Kicau Nusantara 2026',
        badge: 'Grand Prix Nasional',
      ),
      meta: (
        countdown: 'Mulai dalam 2 hari 14 jam',
        judges: 'Juri Bersertifikat Panitia',
        remaining: 'Sisa 4 Gantangan VIP',
      ),
      slot: AgendaSlot(
        date: _peak,
        time: '09:00 WIB',
        venue: 'Batavia Arena Gantangan, Jakarta Barat',
      ),
      prize: 'Rp 150 Jt + 1 Unit Mobil',
    ),
    agendas: _agendas,
  );

  static final List<Agenda> _agendas = <Agenda>[
    Agenda(
      organizer: (
        initials: 'BKS',
        name: 'Bina Kicau Sejahtera',
        tag: 'BOB 24G',
      ),
      title: 'Batavia Cup Seri Nasional',
      slot: AgendaSlot(
        date: _peak,
        time: 'Sesi 1 (09:00 WIB)',
        venue: 'Batavia Arena, Jakarta Barat',
      ),
      offer: (
        priceLabel: 'Tiket Mulai',
        price: 'Rp 150.000',
        cta: 'Pilih Sesi',
      ),
      tags: const AgendaTags(
        region: ScheduleRegion.jabodetabek,
        category: BirdCategory.muraiBatu,
        accent: AgendaAccent.periwinkle,
        badge: (kind: AgendaBadgeKind.open, label: 'Buka'),
      ),
      quota: (filledPercent: 80, remaining: 8),
      note: 'Trofi Mahkota + Hadiah Rp 25 Jt',
    ),
    Agenda(
      organizer: (initials: 'NSR', name: 'Nusa Suara Raya', tag: null),
      title: 'Latpres Minggu Ceria',
      slot: AgendaSlot(
        date: _peak,
        time: 'Sesi 2 (13:00 WIB)',
        venue: 'Taman Burung TMII, Jakarta Timur',
      ),
      offer: (
        priceLabel: 'Rentang Tiket',
        price: 'Rp 50rb - 100rb',
        cta: 'Daftar',
      ),
      tags: const AgendaTags(
        region: ScheduleRegion.jabodetabek,
        category: BirdCategory.kacer,
        accent: AgendaAccent.pink,
        badge: (kind: AgendaBadgeKind.almostFull, label: '85% Penuh'),
      ),
      note: 'Harga Kaki Lima, Kualitas Bintang Lima',
    ),
    Agenda(
      organizer: (initials: 'MKI', name: 'Mitra Kicau Indonesia', tag: null),
      title: 'Bandung Kenari Open',
      slot: AgendaSlot(
        date: _peak,
        time: 'Sesi Murai & Kenari (08:00 WIB)',
        venue: 'Lapangan Gasibu, Bandung',
      ),
      offer: (
        priceLabel: 'Harga Promosi',
        price: 'Rp 200.000',
        cta: 'Klaim Diskon',
      ),
      tags: const AgendaTags(
        region: ScheduleRegion.jawaBarat,
        category: BirdCategory.kenari,
        accent: AgendaAccent.lime,
        badge: (kind: AgendaBadgeKind.promo, label: 'Early Bird Diskon 20%'),
      ),
    ),
    Agenda(
      organizer: (initials: 'SKS', name: 'Semarang Kicau Sentosa', tag: null),
      title: 'Piala Lawang Sewu Cup',
      slot: AgendaSlot(
        date: _peak,
        time: 'Sesi 1 (10:00 WIB)',
        venue: 'Taman Indonesia Kaya, Semarang',
      ),
      offer: (
        priceLabel: 'Tiket Mulai',
        price: 'Rp 100.000',
        cta: 'Pilih Sesi',
      ),
      tags: const AgendaTags(
        region: ScheduleRegion.jawaTengah,
        category: BirdCategory.cucakHijau,
        accent: AgendaAccent.periwinkle,
        badge: (kind: AgendaBadgeKind.open, label: 'Buka'),
      ),
      quota: (filledPercent: 40, remaining: 24),
    ),
    Agenda(
      organizer: (
        initials: 'BSF',
        name: 'Batavia SF Komunitas',
        tag: 'Malam Hari',
      ),
      title: 'Latber Eksklusif Malam Jumat',
      slot: AgendaSlot(
        date: DateTime(2026, 11, 19),
        time: 'Malam (19:30 WIB)',
        venue: 'Batavia Night Park, Jakarta Barat',
      ),
      offer: (
        priceLabel: 'Tiket Komunitas',
        price: 'Rp 35.000',
        cta: 'Daftar Sesi',
      ),
      tags: const AgendaTags(
        region: ScheduleRegion.jabodetabek,
        category: BirdCategory.muraiBatu,
        accent: AgendaAccent.yellow,
        badge: (kind: AgendaBadgeKind.info, label: 'Non-Kroto Friendly'),
      ),
    ),
    Agenda(
      organizer: (initials: 'KTA', name: 'Kicau Tangerang Asri', tag: null),
      title: 'Latber Anis Merah Tangerang',
      slot: AgendaSlot(
        date: DateTime(2026, 11, 20),
        time: 'Sesi 1 (14:00 WIB)',
        venue: 'Lapangan Kicau Cikokol, Tangerang',
      ),
      offer: (priceLabel: 'Tiket Mulai', price: 'Rp 60.000', cta: 'Pilih Sesi'),
      tags: const AgendaTags(
        region: ScheduleRegion.jabodetabek,
        category: BirdCategory.anisMerah,
        accent: AgendaAccent.lime,
        badge: (kind: AgendaBadgeKind.open, label: 'Buka'),
      ),
      quota: (filledPercent: 55, remaining: 18),
    ),
    Agenda(
      organizer: (initials: 'SBC', name: 'Surabaya Bird Club', tag: null),
      title: 'Lovebird Fest Surabaya',
      slot: AgendaSlot(
        date: DateTime(2026, 11, 21),
        time: 'Sesi 1 (09:00 WIB)',
        venue: 'Taman Bungkul, Surabaya',
      ),
      offer: (
        priceLabel: 'Rentang Tiket',
        price: 'Rp 40rb - 80rb',
        cta: 'Daftar',
      ),
      tags: const AgendaTags(
        region: ScheduleRegion.jawaTimur,
        category: BirdCategory.lovebird,
        accent: AgendaAccent.pink,
        badge: (kind: AgendaBadgeKind.almostFull, label: '90% Penuh'),
      ),
    ),
  ];

  @override
  Future<ScheduleContent> fetchScheduleContent() async {
    await Future<void>.delayed(delay);
    return content;
  }
}
