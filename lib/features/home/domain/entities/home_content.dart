import 'package:equatable/equatable.dart';

import 'active_ticket.dart';
import 'featured_contest.dart';
import 'home_stats.dart';
import 'schedule_item.dart';
import 'upcoming_contest.dart';

/// Ringkasan kecil di bagian atas Beranda dan badge navigasi.
///
/// Sebagian field (greeting, fullName, avatarUrl, dll.) berasal dari
/// endpoint `/api/v1/home/profile`; sisanya tetap demo.
class HomeSummary extends Equatable {
  const HomeSummary({
    required this.location,
    required this.liveCount,
    required this.activeTicketCount,
    this.greeting = '',
    this.fullName = '',
    this.avatarUrl,
    this.searchRadiusKM = 0,
    this.favoriteCategories = const <({int id, String name})>[],
    this.isComplete = false,
    this.missingFields = const <String>[],
  });

  final String location;
  final int liveCount;
  final int activeTicketCount;
  final String greeting;
  final String fullName;
  final String? avatarUrl;
  final int searchRadiusKM;
  final List<({int id, String name})> favoriteCategories;
  final bool isComplete;
  final List<String> missingFields;

  @override
  List<Object?> get props => [
    location,
    liveCount,
    activeTicketCount,
    greeting,
    fullName,
    avatarUrl,
    searchRadiusKM,
    favoriteCategories,
    isComplete,
    missingFields,
  ];
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
