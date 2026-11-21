import 'package:equatable/equatable.dart';

/// Konten halaman riwayat tiket & invoice.
class TicketHistoryContent extends Equatable {
  const TicketHistoryContent({this.loaded = true});

  final bool loaded;

  @override
  List<Object?> get props => [loaded];
}
