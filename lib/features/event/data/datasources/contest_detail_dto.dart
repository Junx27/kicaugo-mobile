import '../../../../core/network/json_mapper.dart';
import '../../domain/entities/contest_detail.dart';

/// Mapping payload endpoint detail lomba ke entity domain.
abstract final class ContestDetailDto {
  static ContestDetail fromJson(Map<String, dynamic> json) {
    final quotaJson = _objectOrEmpty(json['quota']);
    final scheduleJson = _objectOrEmpty(json['schedule']);
    final locationJson = _objectOrEmpty(json['location']);
    final prizeJson = _objectOrEmpty(json['prize']);
    final statsJson = _objectOrEmpty(json['stats']);
    final ticketJson = _objectOrEmpty(json['ticket']);
    final formatJson = _objectOrEmpty(statsJson['format']);
    final judgingJson = _objectOrEmpty(statsJson['judging']);
    final facilitiesJson = _objectOrEmpty(statsJson['facilities']);

    return ContestDetail(
      id: _int(json['id']) ?? 0,
      header: ContestDetailHeader(
        title: _text(json, 'title'),
        subtitle: _text(json, 'subtitle'),
        officialBadge: _text(json, 'official_badge'),
        formatBadge: _text(json, 'format_badge'),
        editionLabel: _text(json, 'edition_label'),
        heroImageUrl: _stringOrNull(json['hero_image_url']),
        bannerImageUrl: _stringOrNull(json['banner_image_url']),
        status: _text(json, 'status'),
      ),
      info: ContestDetailInfo(
        quota: ContestQuota(
          total: _int(quotaJson['total']) ?? 0,
          remaining: _int(quotaJson['remaining']),
          label: _text(quotaJson, 'label'),
        ),
        schedule: ContestSchedule(
          date: _text(scheduleJson, 'date'),
          time: _text(scheduleJson, 'time'),
          gateOpen: _text(scheduleJson, 'gate_open'),
        ),
        location: ContestLocation(
          name: _text(locationJson, 'name'),
          address: _text(locationJson, 'address'),
          distance: _text(locationJson, 'distance'),
          mapImageUrl: _stringOrNull(locationJson['map_image_url']),
          latitude: _double(locationJson['latitude']),
          longitude: _double(locationJson['longitude']),
          parking: _text(locationJson, 'parking'),
        ),
        prize: ContestPrize(
          total: _text(prizeJson, 'total'),
          trophy: _text(prizeJson, 'trophy'),
          highlight: _text(prizeJson, 'highlight'),
        ),
        stats: ContestStats(
          format: ContestStatItem(
            label: _text(formatJson, 'label'),
            note: _text(formatJson, 'note'),
          ),
          judging: ContestStatItem(
            label: _text(judgingJson, 'label'),
            note: _text(judgingJson, 'note'),
          ),
          facilities: ContestStatItem(
            label: _text(facilitiesJson, 'label'),
            note: _text(facilitiesJson, 'note'),
          ),
        ),
        ticket: ContestTicket(
          startingPrice: _text(ticketJson, 'starting_price'),
          unit: _text(ticketJson, 'unit'),
          cta: _text(ticketJson, 'cta'),
        ),
        distance: _text(json, 'distance'),
        scheduleText: _text(json, 'schedule_text'),
      ),
      classes: _classesFromJson(JsonMapper.list(json, 'classes')),
      rules: _rulesFromJson(JsonMapper.list(json, 'rules')),
    );
  }

  static List<ContestClass> _classesFromJson(List<Object?> values) {
    final result = <ContestClass>[];
    for (final value in values) {
      final item = JsonMapper.object(value);
      result.add(
        ContestClass(
          id: _int(item['id']) ?? 0,
          name: _text(item, 'name'),
          session: _text(item, 'session'),
          time: _text(item, 'time'),
          remainingSlots: _int(item['remaining_slots']),
          price: _text(item, 'price'),
          prizeHighlight: _text(item, 'prize_highlight'),
        ),
      );
    }
    return result;
  }

  static List<ContestRule> _rulesFromJson(List<Object?> values) {
    final result = <ContestRule>[];
    for (final value in values) {
      final item = JsonMapper.object(value);
      result.add(
        ContestRule(
          title: _text(item, 'title'),
          description: _text(item, 'description'),
          severity: _text(item, 'severity'),
        ),
      );
    }
    return result;
  }

  static Map<String, dynamic> _objectOrEmpty(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static String _text(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is String) return value;
    return '';
  }

  static String? _stringOrNull(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  static int? _int(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return null;
  }

  static double? _double(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }
}
