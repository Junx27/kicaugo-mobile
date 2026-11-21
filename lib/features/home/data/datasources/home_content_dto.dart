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
    summary: _summary(JsonMapper.object(json['summary'])),
    featured: _featured(JsonMapper.object(json['featured'])),
    upcoming: _upcoming(JsonMapper.object(json['upcoming'])),
    stats: _stats(JsonMapper.object(json['stats'])),
    activeTicket: _activeTicket(JsonMapper.object(json['activeTicket'])),
    schedules: _schedules(JsonMapper.list(json, 'schedules')),
  );

  static HomeSummary _summary(Map<String, dynamic> json) => HomeSummary(
    location: JsonMapper.string(json, 'location'),
    liveCount: JsonMapper.integer(json, 'liveCount'),
    activeTicketCount: JsonMapper.integer(json, 'activeTicketCount'),
  );

  static FeaturedContest _featured(Map<String, dynamic> json) {
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

  static UpcomingContest _upcoming(Map<String, dynamic> json) =>
      UpcomingContest(
        type: JsonMapper.string(json, 'type'),
        title: JsonMapper.string(json, 'title'),
        time: JsonMapper.string(json, 'time'),
        price: JsonMapper.string(json, 'price'),
        remainingTickets: JsonMapper.integer(json, 'remainingTickets'),
      );

  static HomeStats _stats(Map<String, dynamic> json) => HomeStats(
    badge: JsonMapper.string(json, 'badge'),
    headline: JsonMapper.string(json, 'headline'),
    note: JsonMapper.string(json, 'note'),
    securityNote: JsonMapper.string(json, 'securityNote'),
  );

  static ActiveTicket _activeTicket(Map<String, dynamic> json) => ActiveTicket(
    event: JsonMapper.string(json, 'event'),
    schedule: JsonMapper.string(json, 'schedule'),
    number: JsonMapper.string(json, 'number'),
    session: JsonMapper.string(json, 'session'),
  );

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
