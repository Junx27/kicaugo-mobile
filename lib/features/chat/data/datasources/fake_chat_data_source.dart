import '../../domain/entities/chat_session.dart';
import 'chat_data_source.dart';

class FakeChatDataSource implements ChatDataSource {
  const FakeChatDataSource({this.delay = const Duration(milliseconds: 300)});

  final Duration delay;

  static const List<ChatSession> sessions = <ChatSession>[
    ChatSession(
      id: 'piala-raja',
      title: 'Piala Raja Nusantara',
      category: ChatCategory.organizer,
      avatar: ChatAvatar.trophy,
      time: '09:42',
      preview: 'Gantangan G-24 sudah terkonfirmasi untuk sesi Murai Batu.',
      unread: 2,
      verified: true,
    ),
    ChatSession(
      id: 'om-hendra',
      title: 'Om Hendra Susanto • Korlap Paddock',
      category: ChatCategory.organizer,
      avatar: ChatAvatar.agent,
      time: '08:15',
      preview: 'Siap om, jaring cadangan sudah kami siapkan di Paddock 2.',
      online: true,
    ),
    ChatSession(
      id: 'batavia-sf',
      title: 'Batavia SF (Kroto Squad)',
      category: ChatCategory.community,
      avatar: ChatAvatar.group,
      time: '10:14',
      preview: 'Om Deni: Diskusi rawatan extra fooding kroto H-1...',
      unread: 3,
      members: '24 anggota',
    ),
    ChatSession(
      id: 'tangsel-bersatu',
      title: 'Kicaumania Tangsel Bersatu',
      category: ChatCategory.community,
      avatar: ChatAvatar.bird,
      time: 'Kemarin',
      preview: 'Jadwal kopdar settingan sangkar seragam hari Minggu...',
    ),
    ChatSession(
      id: 'bantuan-resmi',
      title: 'Bantuan KicauGo Official',
      category: ChatCategory.organizer,
      avatar: ChatAvatar.support,
      time: 'Kemarin',
      preview: 'Klaim ganti sesi lomba Latber Ramadhan telah diproses.',
      support: true,
    ),
    ChatSession(
      id: 'forum-murai',
      title: 'Forum Murai Batu Nusantara',
      category: ChatCategory.community,
      avatar: ChatAvatar.forum,
      time: '2 hari lalu',
      preview: 'Sharing tips pemasteran cililin & kapas tembak.',
    ),
  ];

  @override
  Future<List<ChatSession>> fetchSessions() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    return sessions;
  }
}
