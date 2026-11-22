import 'package:equatable/equatable.dart';

import 'active_ticket.dart';
import 'featured_contest.dart';
import 'home_profile.dart';
import 'home_stats.dart';
import 'schedule_item.dart';
import 'upcoming_contest.dart';

/// Seluruh data yang ditampilkan di Beranda.
class HomeContent extends Equatable {
  const HomeContent({
    required this.profile,
    required this.featured,
    required this.upcoming,
    required this.stats,
    required this.activeTicket,
    required this.schedules,
  });

  final HomeProfile profile;
  final FeaturedContest featured;
  final UpcomingContest upcoming;
  final HomeStats stats;
  final ActiveTicket activeTicket;
  final List<ScheduleItem> schedules;

  @override
  List<Object?> get props => [
    profile,
    featured,
    upcoming,
    stats,
    activeTicket,
    schedules,
  ];
}
