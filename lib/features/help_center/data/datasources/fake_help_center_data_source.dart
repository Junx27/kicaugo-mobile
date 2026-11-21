import '../../domain/entities/help_center_content.dart';
import 'help_center_data_source.dart';

/// Sumber data dummy untuk halaman Pusat Bantuan.
///
/// DATA DEMO: nama panitia, nomor kontak, dan jadwal di sini fiktif.
class FakeHelpCenterDataSource implements HelpCenterDataSource {
  const FakeHelpCenterDataSource({
    this.delay = const Duration(milliseconds: 400),
  });

  final Duration delay;

  static const HelpCenterContent content = HelpCenterContent(
    event: HelpEventInfo(
      title: 'Piala Raja Nusantara 2025 (PBI)',
      venue: 'Batavia Arena Gantangan, Jakarta Timur',
      fieldHours: '07:00 – 18:00 WIB',
      registrationLabel: 'Event Mendatang Terdaftar',
    ),
    quickActions: <HelpQuickAction>[
      HelpQuickAction(
        id: 'chat',
        kind: HelpActionKind.chat,
        title: 'Chat WA Panitia',
        description: 'Kendala darurat H-1 & saat gelaran gantangan.',
        badge: '< 5 Menit',
        ctaLabel: 'Chat Sekarang',
      ),
      HelpQuickAction(
        id: 'refund',
        kind: HelpActionKind.refund,
        title: 'Klaim & Refund',
        description: 'Gacoan mabung, batal sesi, atau force majeure.',
        badge: 'Otomatis',
        ctaLabel: 'Form Refund',
      ),
      HelpQuickAction(
        id: 'appeal',
        kind: HelpActionKind.appeal,
        title: 'Banding Juri',
        description: 'Sanggahan pakem PBI, BnR & RGN pasca lomba.',
        badge: 'Pakem Resmi',
        ctaLabel: 'Ajukan Banding',
      ),
      HelpQuickAction(
        id: 'payment',
        kind: HelpActionKind.payment,
        title: 'Cek Transaksi',
        description: 'Status pembayaran gantung atau tiket dobel.',
        badge: 'QRIS & VA',
        ctaLabel: 'Verifikasi',
      ),
    ],
    contacts: <HelpContact>[
      HelpContact(
        id: 'hendra',
        kind: HelpContactKind.coordinator,
        name: 'Om Hendra Susanto',
        role: 'Koordinator Tiket & Paddock Gantangan',
        actionLabel: 'Telepon',
      ),
      HelpContact(
        id: 'medical',
        kind: HelpContactKind.medical,
        name: 'Unit Tanggap Burung Lepas & Medis',
        role: 'Jaring Evakuasi & Kotak P3K Gacoan',
        actionLabel: 'Panggil',
      ),
      HelpContact(
        id: 'secretariat',
        kind: HelpContactKind.secretariat,
        name: 'Sekretariat EO Batavia Arena',
        role: 'Klaim Piagam, Trophy & Sertifikat DNA',
        actionLabel: 'Meja EO',
      ),
    ],
    faqs: <HelpFaq>[
      HelpFaq(
        id: 'gantangan',
        question: 'Bagaimana jika nomor gantangan ganda atau tertukar?',
        answer:
            'Langsung tunjukkan Bukti QR E-Tiket KicauGo kepada Om Hendra di '
            'Paddock Panitia. Sistem otomatis memvalidasi timestamp pelunasan '
            'detik pertama, dan panitia lapangan menyiapkan nomor gantangan '
            'buffer sekelas tanpa biaya tambahan.',
      ),
      HelpFaq(
        id: 'pengganti',
        question: 'Syarat sah burung pengganti jika gacoan macet/mabung?',
        answer:
            'Penggantian burung diizinkan maksimal 30 menit sebelum sesi kelas '
            'dimulai. Buka menu tiket KicauGo > Ubah Data Gacoan > upload foto '
            'ring kaki terbaru gacoan cadangan. Tidak ada penalti biaya '
            'perubahan identitas burung.',
      ),
      HelpFaq(
        id: 'silent',
        question: 'Tata tertib non-teriak (silent) & sangkar seragam?',
        answer:
            'Area pagar steril berjarak 5 meter. Teriak atau menyebut nomor '
            'gantangan akan dikenakan Kartu Kuning (peringatan) dan Kartu '
            'Merah (diskualifikasi nilai). Untuk kelas wajib sangkar seragam, '
            'stiker barcode resmi dibagikan di meja EO saat check-in.',
      ),
      HelpFaq(
        id: 'offline',
        question: 'Cara scan tiket QR offline di area tanpa sinyal gantangan?',
        answer:
            'Buka tiket Anda sebelum tiba di gantangan dan klik tombol '
            '"Simpan Mode Offline". Aplikasi mengunci token QR kriptografis '
            'lokal sehingga scanner petugas pintu pagar tetap valid membaca '
            'nomor gantangan tanpa kuota internet.',
      ),
    ],
  );

  @override
  Future<HelpCenterContent> fetchHelpCenterContent() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return content;
  }
}
