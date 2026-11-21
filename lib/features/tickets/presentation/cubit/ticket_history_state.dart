import 'package:equatable/equatable.dart';

import '../../domain/entities/ticket_history_content.dart';

enum TicketHistoryStatus { initial, loading, success, failure }

class TicketHistoryState extends Equatable {
  const TicketHistoryState({
    this.status = TicketHistoryStatus.initial,
    this.content,
    this.message,
  });

  final TicketHistoryStatus status;
  final TicketHistoryContent? content;
  final String? message;

  @override
  List<Object?> get props => [status, content, message];
}
