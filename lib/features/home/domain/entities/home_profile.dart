import 'package:equatable/equatable.dart';

/// Profil pengguna versi ringkas dari endpoint `/api/v1/home/profile`.
///
/// Backend mengirim nama, avatar, sapaan, jumlah lomba live, dan status
/// organizer. Field lain pada ringkasan Beranda tidak memiliki sumber dari
/// endpoint ini.
class HomeProfile extends Equatable {
  const HomeProfile({
    required this.name,
    this.avatarUrl,
    required this.greeting,
    required this.liveCount,
    this.isOrganizer = false,
  });

  /// Nama tampilan pengguna (dari `name`).
  final String name;

  /// URL avatar; null bila pengguna belum mengunggah (dari `avatar`).
  final String? avatarUrl;

  /// Sapaan yang ditampilkan di Beranda (dari `message`).
  final String greeting;

  /// Jumlah lomba yang sedang berlangsung (dari `live_count`).
  final int liveCount;

  /// Status organizer pengguna (dari `is_organizer`).
  final bool isOrganizer;

  @override
  List<Object?> get props => [
    name,
    avatarUrl,
    greeting,
    liveCount,
    isOrganizer,
  ];
}
