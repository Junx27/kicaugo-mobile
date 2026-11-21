import 'package:equatable/equatable.dart';

import 'past_ticket.dart';
import 'ticket_stat.dart';
import 'upcoming_ticket.dart';

/// Ringkasan prestasi dan status ring digital.
typedef TicketStats = ({TicketStat podium, TicketStat ring});

/// Seluruh data halaman Tiket Saya.
class TicketsContent extends Equatable {
  const TicketsContent({
    required this.upcoming,
    required this.history,
    required this.cancelled,
    required this.stats,
  });

  final List<UpcomingTicket> upcoming;
  final List<PastTicket> history;
  final List<PastTicket> cancelled;
  final TicketStats stats;

  @override
  List<Object?> get props => [upcoming, history, cancelled, stats];
}
