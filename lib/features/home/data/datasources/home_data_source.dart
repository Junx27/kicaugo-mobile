import '../../../../core/entities/bird_category.dart';
import '../../../../core/entities/ticket_status.dart';
import '../../../event/domain/entities/featured_contest.dart';
import '../../domain/entities/active_ticket.dart';
import '../../domain/entities/bird_category_item.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/entities/home_profile.dart';
import '../../domain/entities/home_stats.dart';
import '../../domain/entities/schedule_item.dart';
import '../../domain/entities/upcoming_contest.dart';

/// Kontrak sumber data Beranda.
abstract interface class HomeDataSource {
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  });
}

/// Sumber data demo untuk Beranda.
///
/// Semua nama lomba, angka, dan klaim di sini adalah DATA DEMO.
class HomeDemoDataSource implements HomeDataSource {
  const HomeDemoDataSource({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;

  /// Fallback saat endpoint kategori belum tersedia.
  static const List<BirdCategoryItem> categories = <BirdCategoryItem>[
    BirdCategoryItem(
      id: 1,
      name: 'Murai Batu',
      slug: 'murai_batu',
      icon: '${BirdCategoryItem.iconDirectory}murai_batu.svg',
    ),
    BirdCategoryItem(
      id: 2,
      name: 'Cucak Hijau',
      slug: 'cucak_hijau',
      icon: '${BirdCategoryItem.iconDirectory}cucak_hijau.svg',
    ),
    BirdCategoryItem(
      id: 3,
      name: 'Kacer',
      slug: 'kacer',
      icon: '${BirdCategoryItem.iconDirectory}kacer.svg',
    ),
    BirdCategoryItem(
      id: 4,
      name: 'Anis Merah',
      slug: 'anis_merah',
      icon: '${BirdCategoryItem.iconDirectory}anis_merah.svg',
    ),
    BirdCategoryItem(
      id: 5,
      name: 'Kenari',
      slug: 'kenari',
      icon: '${BirdCategoryItem.iconDirectory}kenari.svg',
    ),
    BirdCategoryItem(
      id: 6,
      name: 'Lovebird',
      slug: 'lovebird',
      icon: '${BirdCategoryItem.iconDirectory}lovebird.svg',
    ),
  ];

  static const HomeContent content = HomeContent(
    profile: HomeProfile(
      name: '',
      avatarUrl: null,
      greeting: '',
      liveCount: 14,
      isOrganizer: false,
    ),
    featured: FeaturedContest(
      title: 'Piala Raja Nusantara 2026',
      schedule: 'Minggu, 6 Des • Batavia Arena, Jaksel',
      distance: '3.2 KM',
      prize: 'Rp 50 Jt',
      slots: '12 Gantangan',
      attendees: (initials: <String>['MK', 'BN'], others: 48),
      latitude: -6.200000,
      longitude: 106.816666,
    ),
    upcoming: UpcomingContest(
      type: 'Latber Presisi',
      title: 'Latber Presisi Kacer',
      time: 'Besok, 14:00 WIB',
      price: 'Rp 75.000',
      remainingTickets: 3,
    ),
    stats: HomeStats(
      badge: '100% Resmi',
      headline: '520+ Gantangan',
      note: 'Terverifikasi panitia & EO resmi.',
      securityNote: '98% Transaksi Tiket Instan & Aman',
    ),
    activeTicket: ActiveTicket(
      event: 'Grand Prix Murai Batu VIP #18',
      schedule: 'Sabtu, 12 Des • Masterpiece Arena',
      number: '#G-18',
      session: 'Sesi A - 16G',
    ),
    schedules: <ScheduleItem>[
      ScheduleItem(
        title: 'Latpres Exclusive Cucak Ijo',
        venue: 'Arena Master Cilandak, Jaksel',
        date: 'Selasa, 24 Nov',
        price: 'Rp 100rb',
        status: TicketStatus.available,
        category: BirdCategory.cucakHijau,
      ),
      ScheduleItem(
        title: 'Festival Kicau Batavia',
        venue: 'Gantangan Taman Mini, Jaktim',
        date: 'Kamis, 26 Nov',
        price: 'Rp 150rb',
        status: TicketStatus.almostGone,
        category: BirdCategory.muraiBatu,
      ),
      ScheduleItem(
        title: 'Latber Kacer Mingguan',
        venue: 'Lapangan Kicau Pesanggrahan, Jaksel',
        date: 'Sabtu, 28 Nov',
        price: 'Rp 60rb',
        status: TicketStatus.soldOut,
        category: BirdCategory.kacer,
      ),
      ScheduleItem(
        title: 'Kenari Cup Kemang',
        venue: 'Kemang Bird Park, Jaksel',
        date: 'Minggu, 29 Nov',
        price: 'Rp 85rb',
        status: TicketStatus.waiting,
        category: BirdCategory.kenari,
      ),
    ],
    categories: categories,
  );

  @override
  Future<HomeContent> fetchHomeContent({
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
  }) async {
    await Future<void>.delayed(delay);
    return content;
  }
}
