import 'package:equatable/equatable.dart';

/// Bird club/paguyuban yang bisa diikuti pengguna.
class BirdClub extends Equatable {
  const BirdClub({
    required this.id,
    required this.name,
    required this.initials,
    required this.members,
    required this.trophies,
    this.verified = false,
  });

  final String id;
  final String name;
  final String initials;
  final int members;
  final int trophies;
  final bool verified;

  @override
  List<Object?> get props => [id, name, initials, members, trophies, verified];
}
