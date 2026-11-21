import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/upcoming_ticket.dart';
import '../tickets_strings.dart';
import 'ticket_bits.dart';

/// Kartu ringkas untuk tiket aktif berikutnya.
class CompactTicketCard extends StatelessWidget {
  const CompactTicketCard({super.key, required this.ticket});

  final UpcomingTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(child: _Summary(ticket: ticket)),
              _NumberBox(number: ticket.seat.number),
            ],
          ),
          BirdStrip(
            bird: ticket.bird,
            category: ticket.category,
            showOwner: false,
            trailing: TextButton(
              onPressed: () => showComingSoon(context),
              style:
                  AppTheme.softPillButton(
                    foreground: AppColors.primary,
                    textStyle: AppTextStyles.label,
                  ).copyWith(
                    backgroundColor: const WidgetStatePropertyAll(
                      AppColors.surface,
                    ),
                  ),
              child: const Text(TicketsStrings.ticketDetail),
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.ticket});

  final UpcomingTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const TicketChip(
              label: TicketsStrings.confirmed,
              background: AppColors.lavender,
              foreground: AppColors.primary,
            ),
            Text(
              '${ticket.countdown} ${TicketsStrings.towardsEvent}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        Text(ticket.event.title, style: AppTextStyles.title),
        Text(ticket.event.schedule, style: AppTextStyles.caption),
      ],
    );
  }
}

class _NumberBox extends StatelessWidget {
  const _NumberBox({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lavenderTintStart,
        borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
      ),
      child: Column(
        children: [
          Text(TicketsStrings.numberShort, style: AppTextStyles.eyebrow),
          Text(
            number,
            style: AppTextStyles.title.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
