import 'package:equatable/equatable.dart';

import '../../../../core/entities/bird_category.dart';
import '../../domain/entities/past_ticket.dart';
import '../../domain/entities/tickets_content.dart';
import '../../domain/entities/upcoming_ticket.dart';

/// Status pemuatan halaman tiket.
enum TicketsStatus { initial, loading, success, failure }

/// Tab segmen halaman tiket.
enum TicketsTab { active, history, cancelled }

/// State halaman Tiket Saya: data, tab aktif, dan filter burung.
class TicketsState extends Equatable {
  const TicketsState({
    this.status = TicketsStatus.initial,
    this.content,
    this.message,
    this.tab = TicketsTab.active,
    this.category = BirdCategory.all,
  });

  final TicketsStatus status;
  final TicketsContent? content;
  final String? message;
  final TicketsTab tab;
  final BirdCategory category;

  /// Jumlah tiket per tab tanpa filter, untuk label tab.
  int countFor(TicketsTab target) => switch (target) {
    TicketsTab.active => content?.upcoming.length ?? 0,
    TicketsTab.history => content?.history.length ?? 0,
    TicketsTab.cancelled => content?.cancelled.length ?? 0,
  };

  List<UpcomingTicket> get visibleUpcoming =>
      _filter(content?.upcoming, (ticket) => ticket.category);

  List<PastTicket> get visibleHistory =>
      _filter(content?.history, (ticket) => ticket.category);

  List<PastTicket> get visibleCancelled =>
      _filter(content?.cancelled, (ticket) => ticket.category);

  List<T> _filter<T>(List<T>? items, BirdCategory Function(T) categoryOf) {
    final source = items ?? <T>[];
    if (category == BirdCategory.all) {
      return source;
    }
    return source.where((item) => categoryOf(item) == category).toList();
  }

  TicketsState copyWith({
    TicketsStatus? status,
    TicketsContent? content,
    String? message,
    TicketsTab? tab,
    BirdCategory? category,
  }) {
    return TicketsState(
      status: status ?? this.status,
      content: content ?? this.content,
      message: message,
      tab: tab ?? this.tab,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [status, content, message, tab, category];
}
