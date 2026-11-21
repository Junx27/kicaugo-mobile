import 'package:equatable/equatable.dart';

/// Ringkasan statistik komunitas di kartu lime Beranda.
class HomeStats extends Equatable {
  const HomeStats({
    required this.badge,
    required this.headline,
    required this.note,
    required this.securityNote,
  });

  final String badge;
  final String headline;
  final String note;
  final String securityNote;

  @override
  List<Object?> get props => [badge, headline, note, securityNote];
}
