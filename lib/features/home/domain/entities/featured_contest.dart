import 'package:equatable/equatable.dart';

/// Peserta yang sudah terkonfirmasi: inisial yang ditampilkan dan sisanya.
typedef Attendees = ({List<String> initials, int others});

/// Lomba unggulan terdekat di kartu utama Beranda.
class FeaturedContest extends Equatable {
  const FeaturedContest({
    required this.title,
    required this.schedule,
    required this.distance,
    required this.prize,
    required this.slots,
    required this.attendees,
    this.latitude,
    this.longitude,
  });

  final String title;

  /// Hari, tanggal, dan lokasi dalam satu baris (mis. "Minggu, 6 Des • ...").
  final String schedule;
  final String distance;
  final String prize;
  final String slots;
  final Attendees attendees;

  /// Koordinat venue lomba (nullable bila backend belum mengirim).
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [
    title,
    schedule,
    distance,
    prize,
    slots,
    attendees,
    latitude,
    longitude,
  ];
}
