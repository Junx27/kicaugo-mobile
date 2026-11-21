import '../../domain/entities/bird_club.dart';
import '../../domain/entities/community_content.dart';
import '../../domain/entities/community_poll.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/community_topic.dart';
import '../../domain/entities/trending_discussion.dart';
import 'community_data_source.dart';

/// Sumber data dummy untuk Komunitas.
///
/// DATA DEMO: semua klub, nama orang, kutipan, dan angka di sini fiktif dan
/// tidak mewakili organisasi atau juri nyata mana pun.
class FakeCommunityDataSource implements CommunityDataSource {
  const FakeCommunityDataSource({
    this.delay = const Duration(milliseconds: 400),
  });

  final Duration delay;

  static const CommunityContent content = CommunityContent(
    clubs: <BirdClub>[
      BirdClub(
        id: 'batavia-sf',
        name: 'Batavia SF',
        initials: 'BSF',
        members: 4200,
        trophies: 128,
        verified: true,
      ),
      BirdClub(
        id: 'royal-kacer',
        name: 'Royal Kacer',
        initials: 'RK',
        members: 2800,
        trophies: 85,
        verified: true,
      ),
      BirdClub(
        id: 'duta-kicau',
        name: 'Duta Kicau Reg.',
        initials: 'DK',
        members: 3500,
        trophies: 210,
      ),
    ],
    trending: TrendingDiscussion(
      title: 'Pakem Penjurian 2026: Durasi Kerja & Volume Materi',
      author: 'Om Hendra (Juri Senior Komunitas)',
      quote:
          '“Mulai bulan depan, penilaian irama lagu dan durasi kerja di '
          'gantangan 24G akan menitikberatkan pada kestabilan buang materi...”',
      replies: 142,
      views: 890,
      likes: 35,
    ),
    poll: CommunityPoll(
      question:
          'Settingan Ekstra Fooding (EF) Kroto untuk Murai Batu H-1 '
          'Gantangan:',
      closesIn: '18 jam lagi',
      options: <PollOption>[
        PollOption(label: 'Pagi 1 sdt + Sore jangkrik', votes: 880),
        PollOption(label: 'Full jangkrik tanpa kroto', votes: 398),
        PollOption(label: 'Campur ulat hongkong', votes: 142),
      ],
    ),
    posts: <CommunityPost>[
      CommunityPost(
        id: 'post-1',
        author: PostAuthor(
          name: 'Budi Santoso',
          initials: 'BS',
          tag: 'Batavia SF',
          meta: 'Owner Halilintar (#G-18) • 15 mnt lalu',
        ),
        topic: CommunityTopic.careTips,
        hashtag: '#TipsRawatan',
        body:
            'Tips mengatasi murai batu yang nge-batman saat digantang pada '
            'sesi siang panas terik. Ada yang biasa pakai mandi malam H-2? '
            'Sharing pengalamannya suhu sekalian!',
        counts: (replies: 38, likes: 124),
      ),
      CommunityPost(
        id: 'post-2',
        author: PostAuthor(
          name: 'Andi Pratama',
          initials: 'AP',
          tag: 'Breeder Murai Medan',
          meta: '1 jam lalu',
        ),
        topic: CommunityTopic.muraiBatu,
        hashtag: '#ShowcaseJuara',
        body:
            'Alhamdulillah anakan trah Halilintar x Mahadewi perdana podium 1 '
            'di Latpres Batavia Cup! Suara isian kenari & cililin tembus '
            'tembakan rapat!',
        counts: (replies: 56, likes: 310),
        hasShowcase: true,
      ),
      CommunityPost(
        id: 'post-3',
        author: PostAuthor(
          name: 'Rizky Hidayat',
          initials: 'RH',
          tag: 'Royal Kacer',
          meta: '3 jam lalu',
        ),
        topic: CommunityTopic.kacerCucak,
        hashtag: '#KacerMania',
        body:
            'Kacer saya mulai ngeplong tapi durasi masih pendek di sesi '
            'pertama. Ada saran porsi jangkrik pagi untuk latber Minggu, '
            '22 November?',
        counts: (replies: 21, likes: 64),
      ),
    ],
  );

  @override
  Future<CommunityContent> fetchCommunityContent() async {
    await Future<void>.delayed(delay);
    return content;
  }
}
