import 'package:equatable/equatable.dart';

import '../../../../core/entities/bird_category.dart';
import 'schedule_region.dart';

/// Aksen warna kartu agenda (dipetakan ke tone pastel di presentasi).
enum AgendaAccent { periwinkle, pink, lime, yellow }

/// Jenis lencana status di pojok kartu agenda.
enum AgendaBadgeKind { open, almostFull, promo, info }

/// Penyelenggara: inisial logo, nama, dan label tambahan opsional.
typedef AgendaOrganizer = ({String initials, String name, String? tag});

/// Harga: label, nominal, dan teks tombol aksi.
typedef AgendaOffer = ({String priceLabel, String price, String cta});

/// Kuota gantangan yang sudah terisi.
typedef AgendaQuota = ({int filledPercent, int remaining});

/// Lencana status kartu.
typedef AgendaBadge = ({AgendaBadgeKind kind, String label});

/// Waktu dan tempat pelaksanaan.
class AgendaSlot extends Equatable {
  const AgendaSlot({
    required this.date,
    required this.time,
    required this.venue,
  });

  final DateTime date;

  /// Sesi dan jam (mis. "Sesi 1 (09:00 WIB)").
  final String time;
  final String venue;

  @override
  List<Object?> get props => [date, time, venue];
}

/// Atribut penyaringan dan tampilan kartu.
class AgendaTags extends Equatable {
  const AgendaTags({
    required this.region,
    required this.category,
    required this.accent,
    required this.badge,
  });

  final ScheduleRegion region;
  final BirdCategory category;
  final AgendaAccent accent;
  final AgendaBadge badge;

  @override
  List<Object?> get props => [region, category, accent, badge];
}

/// Satu agenda gantangan pada daftar Jadwal.
class Agenda extends Equatable {
  const Agenda({
    required this.organizer,
    required this.title,
    required this.slot,
    required this.offer,
    required this.tags,
    this.quota,
    this.note,
  });

  final AgendaOrganizer organizer;
  final String title;
  final AgendaSlot slot;
  final AgendaOffer offer;
  final AgendaTags tags;
  final AgendaQuota? quota;

  /// Sorotan singkat (hadiah, tagline) bila ada.
  final String? note;

  @override
  List<Object?> get props => [organizer, title, slot, offer, tags, quota, note];
}
