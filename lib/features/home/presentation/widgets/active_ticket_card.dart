import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/color_pill.dart';
import '../../../../core/widgets/link_button.dart';
import '../../../../core/widgets/tone_card.dart';
import '../../domain/entities/active_ticket.dart';
import '../home_strings.dart';

/// Kartu periwinkle pintasan "Tiket Aktif Mendatang" dengan pratinjau QR.
class ActiveTicketCard extends StatelessWidget {
  const ActiveTicketCard({super.key, required this.ticket});

  final ActiveTicket ticket;

  @override
  Widget build(BuildContext context) {
    return ToneCard(
      tone: AppTones.periwinkle,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          const _Header(),
          _TicketBody(ticket: ticket),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppColors.onLime,
                  ),
                  Text(HomeStrings.showQrHint, style: AppTextStyles.caption),
                ],
              ),
              LinkButton(
                label: HomeStrings.openTicket,
                trailingIcon: Icons.arrow_forward_rounded,
                style: AppTextStyles.button.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                onPressed: () => showComingSoon(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  static const double _iconCircle = 32;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Container(
          width: _iconCircle,
          height: _iconCircle,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.confirmation_number_rounded,
            size: 18,
            color: AppColors.surface,
          ),
        ),
        Expanded(
          child: Text(
            HomeStrings.activeTicketEyebrow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              const ColorPill.dot(size: 6, color: AppColors.onLime),
              Text(
                HomeStrings.readyBadge,
                style: AppTextStyles.eyebrow.copyWith(
                  color: AppColors.onLime,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TicketBody extends StatelessWidget {
  const _TicketBody({required this.ticket});

  final ActiveTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  ticket.event,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  spacing: 6,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    Expanded(
                      child: Text(
                        ticket.schedule,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lavender,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${HomeStrings.ticketNumberPrefix} ${ticket.number}',
                        style: AppTextStyles.eyebrow.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(ticket.session, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const _QrPreview(),
        ],
      ),
    );
  }
}

class _QrPreview extends StatelessWidget {
  const _QrPreview();

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: AppColors.lavenderTintStart,
        borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.qr_code_2_rounded,
            size: 32,
            color: AppColors.primary,
          ),
          Text(
            HomeStrings.scanToEnter,
            style: AppTextStyles.eyebrow.copyWith(
              fontSize: 7,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
