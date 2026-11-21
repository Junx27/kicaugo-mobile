import 'package:equatable/equatable.dart';

/// Acara pada tiket: judul, seri, jadwal, kelas, dan lokasi.
class TicketEvent extends Equatable {
  const TicketEvent({
    required this.title,
    required this.series,
    required this.schedule,
    required this.className,
    required this.venue,
    required this.address,
  });

  final String title;
  final String series;
  final String schedule;
  final String className;
  final String venue;
  final String address;

  @override
  List<Object?> get props => [
    title,
    series,
    schedule,
    className,
    venue,
    address,
  ];
}

/// Posisi gantangan peserta.
class TicketSeat extends Equatable {
  const TicketSeat({
    required this.number,
    required this.label,
    required this.position,
    required this.session,
  });

  /// Nomor gantangan (mis. "#G-18").
  final String number;
  final String label;
  final String position;

  /// Nomor sesi (mis. "04").
  final String session;

  @override
  List<Object?> get props => [number, label, position, session];
}

/// Burung yang didaftarkan pada tiket.
class TicketBird extends Equatable {
  const TicketBird({
    required this.name,
    required this.breed,
    required this.ring,
    required this.owner,
  });

  final String name;
  final String breed;
  final String ring;
  final String owner;

  @override
  List<Object?> get props => [name, breed, ring, owner];
}
