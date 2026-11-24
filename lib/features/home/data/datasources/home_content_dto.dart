import '../../../../core/network/json_mapper.dart';
import '../../domain/entities/bird_category_item.dart';
import '../../domain/entities/featured_contest.dart';
import '../../domain/entities/home_profile.dart';
import '../../domain/entities/upcoming_contest.dart';

/// Mapping payload endpoint Beranda ke entity domain.
abstract final class HomeContentDto {
  /// Parsing profil Beranda dari endpoint `/api/v1/home/profile`.
  static HomeProfile profileFromJson(Map<String, dynamic> json) => HomeProfile(
    name: JsonMapper.string(json, 'name'),
    greeting: JsonMapper.string(json, 'message'),
    liveCount: JsonMapper.integer(json, 'live_count'),
    avatarUrl: _stringOrNull(json['avatar']),
    isOrganizer: json['is_organizer'] == true,
  );

  /// Parsing lomba yang segera berlangsung dari endpoint `/api/v1/home/upcoming`.
  static UpcomingContest upcomingFromJson(Map<String, dynamic> json) =>
      UpcomingContest(
        type: JsonMapper.string(json, 'type'),
        title: JsonMapper.string(json, 'title'),
        time: JsonMapper.string(json, 'time'),
        price: JsonMapper.string(json, 'price'),
        remainingTickets: JsonMapper.integer(json, 'remaining_tickets'),
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
      latitude: _doubleOrNull(json['latitude']),
      longitude: _doubleOrNull(json['longitude']),
    );
  }

  /// Parsing daftar kategori dari endpoint `/api/v1/home/bird-categories`.
  ///
  /// Envelope backend tidak terurai otomatis karena `data` berupa List,
  /// sehingga kategori tetap dibaca dari kunci `data`.
  static List<BirdCategoryItem> birdCategoriesFromJson(
    Map<String, dynamic> json,
  ) {
    final result = <BirdCategoryItem>[];
    for (final value in JsonMapper.list(json, 'data')) {
      final item = JsonMapper.object(value);
      result.add(
        BirdCategoryItem(
          id: JsonMapper.integer(item, 'id'),
          name: JsonMapper.string(item, 'name'),
          slug: JsonMapper.string(item, 'slug'),
          icon: _categoryIcon(JsonMapper.string(item, 'icon')),
        ),
      );
    }
    return result;
  }

  /// Backend mengirim nama file, sementara widget butuh path aset lengkap.
  /// Path yang sudah mengandung direktori dibiarkan apa adanya.
  static String _categoryIcon(String value) =>
      value.contains('/') ? value : '${BirdCategoryItem.iconDirectory}$value';

  static String? _stringOrNull(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  static double? _doubleOrNull(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }
}
