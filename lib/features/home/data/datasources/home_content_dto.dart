import '../../../../core/entities/bird_category.dart';
import '../../../../core/entities/ticket_status.dart';
import '../../../../core/network/json_mapper.dart';
import '../../domain/entities/active_ticket.dart';
import '../../domain/entities/featured_contest.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/entities/home_stats.dart';
import '../../domain/entities/schedule_item.dart';
import '../../domain/entities/upcoming_contest.dart';

/// Mapping payload `/api/v1/home` ke entity domain Beranda.
abstract final class HomeContentDto {
  static HomeContent fromJson(Map<String, dynamic> json) => HomeContent(
    summary: summaryFromJson(JsonMapper.object(json['summary'])),
    featured: featuredFromJson(JsonMapper.object(json['featured'])),
    upcoming: upcomingFromJson(JsonMapper.object(json['upcoming'])),
    stats: statsFromJson(JsonMapper.object(json['stats'])),
    activeTicket: activeTicketFromJson(JsonMapper.object(json['activeTicket'])),
    schedules: schedulesFromJson(json),
  );

  /// Parsing bagian `summary` dari payload utuh maupun endpoint terpisah.
  static HomeSummary summaryFromJson(Map<String, dynamic> json) => HomeSummary(
    location: JsonMapper.string(json, 'location'),
    liveCount: JsonMapper.integer(json, 'liveCount'),
    activeTicketCount: JsonMapper.integer(json, 'activeTicketCount'),
  );

  /// Parsing ringkasan Beranda dari endpoint `/api/v1/home/profile`.
  static HomeSummary summaryFromProfileJson(Map<String, dynamic> json) {
    final profile = JsonMapper.object(json['profile']);
    final nearby = JsonMapper.object(json['nearby']);

    final city = profile['city'];
    var location = 'Jakarta Selatan';
    if (city is Map) {
      final name = city['name'];
      if (name is String && name.isNotEmpty) location = name;
    }

    final avatar = profile['avatar_url'];
    final favoriteCategories = <({int id, String name})>[];
    final rawFavorites = profile['favorite_categories'];
    if (rawFavorites is List) {
      for (final item in rawFavorites) {
        if (item is Map) {
          final id = item['id'];
          final name = item['name'];
          if (id is int && name is String) {
            favoriteCategories.add((id: id, name: name));
          }
        }
      }
    }

    final missingFields = <String>[];
    final rawMissing = profile['missing_fields'];
    if (rawMissing is List) {
      for (final item in rawMissing) {
        if (item is String) missingFields.add(item);
      }
    }

    return HomeSummary(
      location: location,
      liveCount: _intOrZero(nearby['ongoing_events_count']),
      activeTicketCount: 0,
      greeting: _stringOrEmpty(profile['greeting']),
      fullName: _stringOrEmpty(profile['full_name']),
      avatarUrl: avatar is String && avatar.isNotEmpty ? avatar : null,
      searchRadiusKM: _intOrZero(profile['search_radius_km']),
      favoriteCategories: favoriteCategories,
      isComplete: profile['is_complete'] == true,
      missingFields: missingFields,
    );
  }

  static int _intOrZero(Object? value) => value is int ? value : 0;

  static String _stringOrEmpty(Object? value) => value is String ? value : '';

  /// Parsing bagian `featured` dari payload utuh maupun endpoint terpisah.
  static FeaturedContest featuredFromJson(Map<String, dynamic> json) {
    final attendees = JsonMapper.object(json['attendees']);
    return FeaturedContest(
      title: JsonMapper.string(json, 'title'),
      schedule: JsonMapper.string(json, 'schedule'),
      distance: JsonMapper.string(json, 'distance'),
      prize: JsonMapper.string(json, 'prize'),
      slots: JsonMapper.string(json, 'slots'),
      attendees: (
        initials: JsonMapper.strings(attendees, 'initials'),
        others: JsonMapper.integer(attendees, 'others'),
      ),
    );
  }

  /// Parsing bagian `upcoming` dari payload utuh maupun endpoint terpisah.
  static UpcomingContest upcomingFromJson(Map<String, dynamic> json) =>
      UpcomingContest(
        type: JsonMapper.string(json, 'type'),
        title: JsonMapper.string(json, 'title'),
        time: JsonMapper.string(json, 'time'),
        price: JsonMapper.string(json, 'price'),
        remainingTickets: JsonMapper.integer(json, 'remainingTickets'),
      );

  /// Parsing bagian `stats` dari payload utuh maupun endpoint terpisah.
  static HomeStats statsFromJson(Map<String, dynamic> json) => HomeStats(
    badge: JsonMapper.string(json, 'badge'),
    headline: JsonMapper.string(json, 'headline'),
    note: JsonMapper.string(json, 'note'),
    securityNote: JsonMapper.string(json, 'securityNote'),
  );

  /// Parsing bagian `activeTicket` dari payload utuh maupun endpoint terpisah.
  static ActiveTicket activeTicketFromJson(Map<String, dynamic> json) =>
      ActiveTicket(
        event: JsonMapper.string(json, 'event'),
        schedule: JsonMapper.string(json, 'schedule'),
        number: JsonMapper.string(json, 'number'),
        session: JsonMapper.string(json, 'session'),
      );

  /// Parsing daftar jadwal dari payload utuh (`schedules`) maupun endpoint
  /// terpisah (`{ "schedules": [...] }`).
  static List<ScheduleItem> schedulesFromJson(Map<String, dynamic> json) =>
      _schedules(JsonMapper.list(json, 'schedules'));

  static List<ScheduleItem> _schedules(List<Object?> values) => [
    for (final value in values) _schedule(JsonMapper.object(value)),
  ];

  static ScheduleItem _schedule(Map<String, dynamic> json) => ScheduleItem(
    title: JsonMapper.string(json, 'title'),
    venue: JsonMapper.string(json, 'venue'),
    date: JsonMapper.string(json, 'date'),
    price: JsonMapper.string(json, 'price'),
    status: JsonMapper.enumValue(json, 'status', TicketStatus.values),
    category: JsonMapper.enumValue(json, 'category', BirdCategory.values),
  );
}
