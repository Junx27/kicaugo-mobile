import 'package:equatable/equatable.dart';

import '../../../../core/entities/bird_category.dart';

/// Hasil lomba pada tiket yang sudah selesai.
typedef TicketResult = ({String label, String score});

/// Tiket yang sudah selesai atau dibatalkan.
class PastTicket extends Equatable {
  const PastTicket({
    required this.title,
    required this.detail,
    required this.className,
    required this.category,
    this.result,
  });

  final String title;

  /// Tanggal dan nomor gantangan dalam satu baris.
  final String detail;
  final String className;
  final BirdCategory category;

  /// Hasil lomba; `null` untuk tiket yang dibatalkan.
  final TicketResult? result;

  @override
  List<Object?> get props => [title, detail, className, category, result];
}
