import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/link_button.dart';
import '../../domain/entities/past_ticket.dart';
import '../cubit/tickets_state.dart';
import '../tickets_strings.dart';
import 'compact_ticket_card.dart';
import 'hero_ticket_card.dart';
import 'past_ticket_card.dart';
import 'ticket_stats_row.dart';
import 'tickets_filters.dart';

/// Isi tab terpilih, sudah tersaring kategori burung.
class TicketsTabContent extends StatelessWidget {
  const TicketsTabContent({
    super.key,
    required this.state,
    required this.onShowHistory,
  });

  final TicketsState state;
  final VoidCallback onShowHistory;

  @override
  Widget build(BuildContext context) {
    final children = switch (state.tab) {
      TicketsTab.active => _activeChildren(),
      TicketsTab.history => _pastChildren(state.visibleHistory),
      TicketsTab.cancelled => _pastChildren(state.visibleCancelled),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: children,
    );
  }

  List<Widget> _activeChildren() {
    final upcoming = state.visibleUpcoming;
    final history = state.visibleHistory;
    return [
      if (upcoming.isEmpty) const TicketsEmptyView(),
      for (var index = 0; index < upcoming.length; index++)
        index == 0
            ? HeroTicketCard(ticket: upcoming[index])
            : CompactTicketCard(ticket: upcoming[index]),
      TicketStatsRow(stats: state.content!.stats),
      if (history.isNotEmpty) ...[
        _HistoryHeader(
          total: state.countFor(TicketsTab.history),
          onSeeAll: onShowHistory,
        ),
        PastTicketCard(ticket: history.first),
      ],
    ];
  }

  List<Widget> _pastChildren(List<PastTicket> tickets) => [
    if (tickets.isEmpty) const TicketsEmptyView(),
    for (final ticket in tickets) PastTicketCard(ticket: ticket),
  ];
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.total, required this.onSeeAll});

  final int total;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TicketsStrings.historyTitle, style: AppTextStyles.title),
              Text(
                TicketsStrings.historySubtitle,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        LinkButton(
          label: '${TicketsStrings.seeAll} ($total)',
          trailingIcon: Icons.chevron_right_rounded,
          style: AppTextStyles.label,
          onPressed: onSeeAll,
        ),
      ],
    );
  }
}
