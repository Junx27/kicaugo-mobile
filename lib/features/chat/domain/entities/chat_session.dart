import 'package:equatable/equatable.dart';

/// Kategori sesi untuk filter daftar Pesan.
enum ChatCategory { organizer, community }

/// Jenis avatar; dipetakan ke ikon & warna di lapisan presentation.
enum ChatAvatar { trophy, agent, group, bird, support, forum }

/// Satu sesi percakapan.
class ChatSession extends Equatable {
  const ChatSession({
    required this.id,
    required this.title,
    required this.category,
    required this.avatar,
    required this.time,
    required this.preview,
    this.support = false,
    this.unread = 0,
    this.online = false,
    this.verified = false,
    this.members,
  });

  final String id;
  final String title;
  final ChatCategory category;
  final ChatAvatar avatar;
  final String time;
  final String preview;

  /// Menandakan CS resmi (badge "CS Panitia").
  final bool support;
  final int unread;
  final bool online;
  final bool verified;
  final String? members;

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    category,
    avatar,
    time,
    preview,
    support,
    unread,
    online,
    verified,
    members,
  ];
}
