import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_content.dart';

/// Status pemuatan halaman Profil.
enum ProfileStatus { initial, loading, success, failure }

/// State yang dibaca halaman Profil.
class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.content,
    this.message,
  });

  final ProfileStatus status;
  final ProfileContent? content;
  final String? message;

  @override
  List<Object?> get props => [status, content, message];
}
