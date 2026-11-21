import 'package:equatable/equatable.dart';

/// Lomba yang segera berlangsung dengan sisa tiket terbatas.
class UpcomingContest extends Equatable {
  const UpcomingContest({
    required this.type,
    required this.title,
    required this.time,
    required this.price,
    required this.remainingTickets,
  });

  /// Jenis lomba (mis. "Latber Presisi").
  final String type;
  final String title;
  final String time;
  final String price;
  final int remainingTickets;

  @override
  List<Object?> get props => [type, title, time, price, remainingTickets];
}
