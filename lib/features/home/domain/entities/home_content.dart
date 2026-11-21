import 'package:equatable/equatable.dart';

import 'active_ticket.dart';
import 'featured_contest.dart';
import 'home_stats.dart';
import 'schedule_item.dart';
import 'upcoming_contest.dart';

/// Ringkasan kecil di bagian atas Beranda dan badge navigasi.
class HomeSummary extends Equatable {
  const HomeSummary({
    required this.location,
    required this.liveCount,
    required this.activeTicketCount,
  });

  final String location;
  final int liveCount;
  final int activeTicketCount;

  @override
  List<Object?> get props => [location, liveCount, activeTicketCount];
}

/// Seluruh data yang ditampilkan di Beranda.
class HomeContent extends Equatable {
  const HomeContent({
    required this.summary,
    required this.featured,
    required this.upcoming,
    required this.stats,
    required this.activeTicket,
    required this.schedules,
  });

  final HomeSummary summary;
  final FeaturedContest featured;
  final UpcomingContest upcoming;
  final HomeStats stats;
  final ActiveTicket activeTicket;
  final List<ScheduleItem> schedules;

  @override
  List<Object?> get props => [
    summary,
    featured,
    upcoming,
    stats,
    activeTicket,
    schedules,
  ];
}
