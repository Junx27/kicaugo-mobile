import 'package:equatable/equatable.dart';

import '../../../../core/entities/bird_category.dart';
import '../../../../core/entities/ticket_status.dart';

/// Satu jadwal gantangan pada daftar populer.
class ScheduleItem extends Equatable {
  const ScheduleItem({
    required this.title,
    required this.venue,
    required this.date,
    required this.price,
    required this.status,
    required this.category,
  });

  final String title;
  final String venue;
  final String date;
  final String price;
  final TicketStatus status;
  final BirdCategory category;

  @override
  List<Object?> get props => [title, venue, date, price, status, category];
}
