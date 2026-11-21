import 'package:equatable/equatable.dart';

/// Status rawatan burung yang menentukan badge pada kartu amunisi.
enum ProfileBirdStatus { ready, molting, training }

/// Satu slot formula rawatan (mis. Pagi, Sore, Mandi).
typedef BirdCareSlot = ({String label, String value});

/// Identitas anggota yang tampil pada kartu profil.
class ProfileMember extends Equatable {
  const ProfileMember({
    required this.avatarUrl,
    required this.club,
    required this.memberId,
    required this.memberSince,
    this.isVerified = true,
  });

  final String avatarUrl;
  final String club;
  final String memberId;
  final String memberSince;
  final bool isVerified;

  @override
  List<Object?> get props => [
    avatarUrl,
    club,
    memberId,
    memberSince,
    isVerified,
  ];
}

/// Ringkasan performa dan saldo dompet pengguna.
class ProfileStats extends Equatable {
  const ProfileStats({
    required this.trophies,
    required this.medals,
    required this.attendance,
    required this.birdsReady,
    required this.balance,
  });

  final int trophies;
  final String medals;
  final int attendance;
  final int birdsReady;
  final String balance;

  @override
  List<Object?> get props => [
    trophies,
    medals,
    attendance,
    birdsReady,
    balance,
  ];
}

/// Satu burung pada daftar Amunisi Gantangan.
class ProfileBird extends Equatable {
  const ProfileBird({
    required this.name,
    required this.species,
    required this.ringId,
    required this.status,
    required this.imageUrl,
    required this.highlight,
    this.isHero = false,
    this.footerNote,
    this.careSlots = const <BirdCareSlot>[],
  });

  final String name;
  final String species;
  final String ringId;
  final ProfileBirdStatus status;
  final String imageUrl;
  final String highlight;
  final bool isHero;

  /// Catatan rawatan singkat di bawah kartu ringkas.
  final String? footerNote;
  final List<BirdCareSlot> careSlots;

  @override
  List<Object?> get props => [
    name,
    species,
    ringId,
    status,
    imageUrl,
    highlight,
    isHero,
    footerNote,
    careSlots,
  ];
}

/// Seluruh data halaman Profil.
class ProfileContent extends Equatable {
  const ProfileContent({
    required this.member,
    required this.stats,
    required this.birds,
  });

  final ProfileMember member;
  final ProfileStats stats;
  final List<ProfileBird> birds;

  @override
  List<Object?> get props => [member, stats, birds];
}
