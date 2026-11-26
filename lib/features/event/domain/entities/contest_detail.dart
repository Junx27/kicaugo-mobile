import 'package:equatable/equatable.dart';

/// Satu kelas/sesi lomba dalam detail event.
class ContestClass extends Equatable {
  const ContestClass({
    required this.id,
    required this.name,
    required this.session,
    required this.time,
    this.remainingSlots,
    required this.price,
    required this.prizeHighlight,
  });

  final int id;
  final String name;
  final String session;
  final String time;

  /// `null` berarti tersedia tanpa batas.
  final int? remainingSlots;
  final String price;
  final String prizeHighlight;

  String get slotLabel =>
      remainingSlots == null ? 'Tersedia' : 'Sisa $remainingSlots Gantangan';

  @override
  List<Object?> get props => [
    id,
    name,
    session,
    time,
    remainingSlots,
    price,
    prizeHighlight,
  ];
}

/// Aturan/pakem lomba.
class ContestRule extends Equatable {
  const ContestRule({
    required this.title,
    required this.description,
    required this.severity,
  });

  final String title;
  final String description;

  /// `info`, `error`, atau `success`.
  final String severity;

  @override
  List<Object?> get props => [title, description, severity];
}

/// Kuota gantangan lomba.
class ContestQuota extends Equatable {
  const ContestQuota({
    required this.total,
    this.remaining,
    required this.label,
  });

  final int total;
  final int? remaining;
  final String label;

  @override
  List<Object?> get props => [total, remaining, label];
}

/// Jadwal pelaksanaan lomba.
class ContestSchedule extends Equatable {
  const ContestSchedule({
    required this.date,
    required this.time,
    required this.gateOpen,
  });

  final String date;
  final String time;
  final String gateOpen;

  @override
  List<Object?> get props => [date, time, gateOpen];
}

/// Lokasi arena lomba.
class ContestLocation extends Equatable {
  const ContestLocation({
    required this.name,
    required this.address,
    required this.distance,
    this.mapImageUrl,
    this.latitude,
    this.longitude,
    required this.parking,
  });

  final String name;
  final String address;
  final String distance;
  final String? mapImageUrl;
  final double? latitude;
  final double? longitude;
  final String parking;

  @override
  List<Object?> get props => [
    name,
    address,
    distance,
    mapImageUrl,
    latitude,
    longitude,
    parking,
  ];
}

/// Informasi hadiah lomba.
class ContestPrize extends Equatable {
  const ContestPrize({
    required this.total,
    required this.trophy,
    required this.highlight,
  });

  final String total;
  final String trophy;
  final String highlight;

  @override
  List<Object?> get props => [total, trophy, highlight];
}

/// Satu item statistik (format/penjurian/fasilitas).
class ContestStatItem extends Equatable {
  const ContestStatItem({required this.label, required this.note});

  final String label;
  final String note;

  @override
  List<Object?> get props => [label, note];
}

/// Tiga statistik utama lomba.
class ContestStats extends Equatable {
  const ContestStats({
    required this.format,
    required this.judging,
    required this.facilities,
  });

  final ContestStatItem format;
  final ContestStatItem judging;
  final ContestStatItem facilities;

  @override
  List<Object?> get props => [format, judging, facilities];
}

/// Informasi tiket/harga lomba.
class ContestTicket extends Equatable {
  const ContestTicket({
    required this.startingPrice,
    required this.unit,
    required this.cta,
  });

  final String startingPrice;
  final String unit;
  final String cta;

  @override
  List<Object?> get props => [startingPrice, unit, cta];
}

/// Header detail lomba.
class ContestDetailHeader extends Equatable {
  const ContestDetailHeader({
    required this.title,
    required this.subtitle,
    required this.officialBadge,
    required this.formatBadge,
    required this.editionLabel,
    this.heroImageUrl,
    this.bannerImageUrl,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String officialBadge;
  final String formatBadge;
  final String editionLabel;
  final String? heroImageUrl;
  final String? bannerImageUrl;
  final String status;

  @override
  List<Object?> get props => [
    title,
    subtitle,
    officialBadge,
    formatBadge,
    editionLabel,
    heroImageUrl,
    bannerImageUrl,
    status,
  ];
}

/// Info utama detail lomba.
class ContestDetailInfo extends Equatable {
  const ContestDetailInfo({
    required this.quota,
    required this.schedule,
    required this.location,
    required this.prize,
    required this.stats,
    required this.ticket,
    required this.distance,
    required this.scheduleText,
  });

  final ContestQuota quota;
  final ContestSchedule schedule;
  final ContestLocation location;
  final ContestPrize prize;
  final ContestStats stats;
  final ContestTicket ticket;
  final String distance;
  final String scheduleText;

  @override
  List<Object?> get props => [
    quota,
    schedule,
    location,
    prize,
    stats,
    ticket,
    distance,
    scheduleText,
  ];
}

/// Detail lomba lengkap.
class ContestDetail extends Equatable {
  const ContestDetail({
    required this.id,
    required this.header,
    required this.info,
    required this.classes,
    required this.rules,
  });

  final int id;
  final ContestDetailHeader header;
  final ContestDetailInfo info;
  final List<ContestClass> classes;
  final List<ContestRule> rules;

  @override
  List<Object?> get props => [id, header, info, classes, rules];
}
