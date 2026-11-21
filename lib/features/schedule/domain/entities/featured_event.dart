import 'package:equatable/equatable.dart';

import 'agenda.dart';

/// Judul dan lencana utama event unggulan.
typedef FeaturedHeadline = ({String title, String badge});

/// Info pendukung: hitung mundur, juri, dan sisa slot.
typedef FeaturedMeta = ({String countdown, String judges, String remaining});

/// Event unggulan di kartu hero Jadwal.
class FeaturedEvent extends Equatable {
  const FeaturedEvent({
    required this.headline,
    required this.meta,
    required this.slot,
    required this.prize,
  });

  final FeaturedHeadline headline;
  final FeaturedMeta meta;
  final AgendaSlot slot;
  final String prize;

  @override
  List<Object?> get props => [headline, meta, slot, prize];
}
