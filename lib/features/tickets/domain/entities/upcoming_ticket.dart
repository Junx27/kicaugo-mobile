import 'package:equatable/equatable.dart';

import '../../../../core/entities/bird_category.dart';
import 'ticket_parts.dart';

/// Tiket aktif untuk lomba yang belum berlangsung.
class UpcomingTicket extends Equatable {
  const UpcomingTicket({
    required this.code,
    required this.countdown,
    required this.category,
    required this.event,
    required this.seat,
    required this.bird,
  });

  /// Kode e-tiket untuk dipindai saat registrasi ulang.
  final String code;

  /// Jarak hari menuju acara (mis. "H-1").
  final String countdown;
  final BirdCategory category;
  final TicketEvent event;
  final TicketSeat seat;
  final TicketBird bird;

  @override
  List<Object?> get props => [code, countdown, category, event, seat, bird];
}
