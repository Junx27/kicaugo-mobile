import 'package:equatable/equatable.dart';

/// Data minimal yang dibutuhkan halaman pemesanan tiket.
///
/// Dipisahkan dari entitas detail event agar domain tiket tidak bergantung
/// pada domain lain.
class TicketSelectionItem extends Equatable {
  const TicketSelectionItem({
    required this.id,
    required this.name,
    required this.session,
    required this.time,
    required this.price,
  });

  final int id;
  final String name;
  final String session;
  final String time;
  final String price;

  @override
  List<Object?> get props => [id, name, session, time, price];
}
