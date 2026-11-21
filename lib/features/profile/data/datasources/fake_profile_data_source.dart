import '../../domain/entities/profile_content.dart';
import 'profile_data_source.dart';

/// Sumber data dummy untuk halaman Profil.
///
/// DATA DEMO: nama klub, nomor anggota, burung, prestasi, dan saldo di sini
/// fiktif dan tidak mewakili organisasi atau penjurian nyata.
class FakeProfileDataSource implements ProfileDataSource {
  const FakeProfileDataSource({this.delay = const Duration(milliseconds: 400)});

  final Duration delay;

  static const ProfileContent content = ProfileContent(
    member: ProfileMember(
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAKn6WcGZWtx3zD_A9G95QpeNbwG5NBKXmeq1z3KB9IiS_KE7hdGtewfyjXxXJpiMOub8PqmzeYEPUA417jOtKfZCXD1l0KUm9BwA6yEc20nSlsaojSmsgyJACKfPZ9g4BTsBYDdAb7v_n_u9CfaQwcflQHC_vhDlcBDWL1nKD6-2Y89_YHUltGgHSkmBmGuPws22nT5HTuwJh1Yr-9J0YuAiTmrvlJo5Q1D2qDG_Dd',
      club: 'Batavia SF',
      memberId: 'ID-KCG-99201',
      memberSince: 'Anggota sejak November 2022',
    ),
    stats: ProfileStats(
      trophies: 14,
      medals: '5x Emas • 6x Perak • 3x Perunggu',
      attendance: 98,
      birdsReady: 3,
      balance: 'Rp 1.450.000',
    ),
    birds: <ProfileBird>[
      ProfileBird(
        name: 'Halilintar',
        species: 'Murai Batu Medan • Ekor 21cm',
        ringId: 'ID-PBI-2024-8891',
        status: ProfileBirdStatus.ready,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAyqYYDtj86-qxrYF3wT31qTWxnWkGiU7uaW0DBOOLvWlUkjijtlszdzin465COgc7gq5EcJSS9qL5HORJkxfcs20mdswVW_xmCKZTlsIEjBZZwia3pOlZmbrMEZ7LVz2Hv0gaYSu0r6O8B9vIpsaUZFgYvBX9ZaEZaz3vna58msMaa_1MTbRU_oA_IR-jmin60t7xWczKudPdrV6oFdVqIdctkAxuzJAe89A-eWAHu',
        highlight: 'Juara 1 Batavia Cup 2024 • Juara 2 Latpres Ronggolawe',
        isHero: true,
        careSlots: <BirdCareSlot>[
          (label: 'Pagi', value: '5 Jangkrik'),
          (label: 'Sore', value: '5 Jangkrik'),
          (label: 'Mandi', value: 'Malam 20:00'),
        ],
      ),
      ProfileBird(
        name: 'Black Phantom',
        species: 'Kacer Jawa Barat • Ring BnR',
        ringId: 'BNR-JKT-11409',
        status: ProfileBirdStatus.molting,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCm9YoHvILqaUqfxbZMEx8BSMAAPbiTkDm1p7MCxPWkcAC3jZ2Lvdw7brv7rPWIMJm-p01O4fQp4YYeO6rb8veWFecGUriBVLhn_HThj6V29hE2ERRnuXPh4Zgv0aRKTSNuA6FY8vVmlDLqpF-zIsJFpdqXzv4uDoM8jXU5Nws9Ke8Jqy3LDQi419Nltyjy9v7FaTovEhgKBN0dyJEpJWbUAX9Z2XDud7Nx8OyN7Jpq',
        highlight: 'Juara 3 Danlanud Cup',
        footerNote: 'Istirahat total & masteran pelan',
      ),
      ProfileBird(
        name: 'Rawa Rontek',
        species: 'Cucak Ijo Banyuwangi • ORI-JTG-5521',
        ringId: 'ORI-JTG-5521',
        status: ProfileBirdStatus.training,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCpLPp4d9gChYKtxi9wdkY7XMdwyjdydTd1VhlcZrTOq7IP8Jhl-fDHpVIah5rgfRAcFl0UROwn1PugLL_8C-nSDr15MeqPIelSKo8ZDn5Xyg3CRuxu7i5cW4OfAKjZB_VLjZBupEo1DdousVYsncDFzyDGYUFUahzYuvyIoXymdNqfsuJ7yzb6KwYFUVXiPCIpeuA85ojwpbYigimtGkxX9ONVotlI-1WmYTJgRPHR',
        highlight: 'Top Form: Pisang Kepok + Ulat Hongkong',
        footerNote: 'Target Latihan: Kamis Sore',
      ),
    ],
  );

  @override
  Future<ProfileContent> fetchProfileContent() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return content;
  }
}
