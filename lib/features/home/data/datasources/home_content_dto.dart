import '../../../../core/network/json_mapper.dart';
import '../../domain/entities/featured_contest.dart';
import '../../domain/entities/home_profile.dart';

/// Mapping payload endpoint Beranda ke entity domain.
abstract final class HomeContentDto {
  /// Parsing profil Beranda dari endpoint `/api/v1/home/profile`.
  static HomeProfile profileFromJson(Map<String, dynamic> json) => HomeProfile(
    name: JsonMapper.string(json, 'name'),
    greeting: JsonMapper.string(json, 'message'),
    liveCount: JsonMapper.integer(json, 'live_count'),
    avatarUrl: _stringOrNull(json['avatar']),
  );

  /// Parsing lomba unggulan dari endpoint `/api/v1/home/featured`.
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

  static String? _stringOrNull(Object? value) =>
      value is String && value.isNotEmpty ? value : null;
}
