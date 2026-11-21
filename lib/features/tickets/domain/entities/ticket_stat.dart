import 'package:equatable/equatable.dart';

/// Satu kartu statistik ringkas di tab tiket aktif.
class TicketStat extends Equatable {
  const TicketStat({
    required this.headline,
    required this.label,
    required this.note,
  });

  final String headline;
  final String label;
  final String note;

  @override
  List<Object?> get props => [headline, label, note];
}
