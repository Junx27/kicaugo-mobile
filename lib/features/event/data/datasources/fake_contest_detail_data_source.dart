import '../../domain/entities/contest_detail.dart';
import 'contest_detail_data_source.dart';

/// Sumber data contoh detail lomba (mengikuti kontrak BE yang disepakati).
class FakeContestDetailDataSource implements ContestDetailDataSource {
  const FakeContestDetailDataSource({this.delay = Duration.zero});

  final Duration delay;

  static const ContestDetail content = ContestDetail(
    id: 101,
    header: ContestDetailHeader(
      title: 'Piala Raja Nusantara 2025',
      subtitle: 'Batavia Bird Club & PBI Cabang Jakarta',
      officialBadge: 'Resmi PBI & BnR',
      formatBadge: '24G & 36G',
      editionLabel: 'Edisi Akbar Tahunan',
      heroImageUrl: null,
      bannerImageUrl: null,
      status: 'open',
    ),
    info: ContestDetailInfo(
      quota: ContestQuota(total: 36, remaining: 12, label: 'Kuota Tersedia'),
      schedule: ContestSchedule(
        date: 'Minggu, 18 Mei 2025',
        time: '08:30 WIB – Selesai',
        gateOpen: '07:00 WIB',
      ),
      location: ContestLocation(
        name: 'Batavia Arena Gantangan',
        address: 'Jl. RS Fatmawati Raya No. 45, Cilandak, Jakarta Selatan',
        distance: '5 Menit dari Tol TB Simatupang',
        mapImageUrl: 'https://cdn.kicau.go/maps/101.jpg',
        latitude: -6.2915,
        longitude: 106.7950,
        parking: 'Parkir 200+ Kendaraan',
      ),
      prize: ContestPrize(
        total: 'Rp 50.000.000',
        trophy: 'Trofi Eksklusif Mahkota Raja Berlapis Kuningan',
        highlight: 'Rp 20.000.000 + Motor Matic Baru',
      ),
      stats: ContestStats(
        format: ContestStatItem(
          label: '36 Gantangan',
          note: 'Tertib & Terbuka',
        ),
        judging: ContestStatItem(
          label: 'PBI Terbuka',
          note: 'Tanpa Koordinasi',
        ),
        facilities: ContestStatItem(
          label: 'VIP Paddock',
          note: 'LED Live Score',
        ),
      ),
      ticket: ContestTicket(
        startingPrice: 'Rp 150.000',
        unit: '/gantangan',
        cta: 'Beli Tiket',
      ),
      distance: '5 Menit dari Tol TB Simatupang',
      scheduleText: 'Minggu, 18 Mei 2025',
    ),
    classes: [
      ContestClass(
        id: 1,
        name: 'Murai Batu Utama - Raja Batavia',
        session: 'Sesi 04',
        time: '10:30 WIB',
        remainingSlots: 4,
        price: 'Rp 500.000',
        prizeHighlight: 'Juara 1: Rp 20.000.000 + Motor Matic Baru',
      ),
      ContestClass(
        id: 2,
        name: 'Cucak Hijau - Bintang Nusantara',
        session: 'Sesi 07',
        time: '13:00 WIB',
        remainingSlots: 8,
        price: 'Rp 250.000',
        prizeHighlight: 'Juara 1: Rp 10.000.000 + Trofi Mahkota',
      ),
      ContestClass(
        id: 3,
        name: 'Kacer Ring - Masterpiece',
        session: 'Sesi 02',
        time: '09:15 WIB',
        remainingSlots: null,
        price: 'Rp 150.000',
        prizeHighlight: 'Juara 1: Rp 5.000.000 + Piagam Kehormatan',
      ),
    ],
    rules: [
      ContestRule(
        title: 'Aturan Sangkar',
        description:
            'Wajib menggunakan sangkar standar nomor 1 & 2 seragam panitia tanpa variasi mencolok.',
        severity: 'info',
      ),
      ContestRule(
        title: 'Larangan Tegas & Diskualifikasi',
        description:
            'Non-teriak, tanpa isyarat kode, dan dilarang menempel stiker identitas pribadi di gantangan.',
        severity: 'error',
      ),
      ContestRule(
        title: 'Tim Juri Independen',
        description:
            '7 Dewan Juri Senior PBI Terakreditasi Nasional dengan rotasi blok terbuka otomatis.',
        severity: 'success',
      ),
    ],
  );

  @override
  Future<ContestDetail> fetchContestDetail(int id) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return content;
  }
}
