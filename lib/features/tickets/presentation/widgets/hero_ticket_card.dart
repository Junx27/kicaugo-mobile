import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/navigation_url_builder.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/pulse_badge.dart';
import '../../../home/presentation/widgets/venue_map_preview.dart';
import '../../domain/entities/upcoming_ticket.dart';
import '../tickets_strings.dart';
import 'ticket_bits.dart';

/// Kartu tiket utama (paling dekat) lengkap dengan sobekan dan aksi masuk.
class HeroTicketCard extends StatelessWidget {
  const HeroTicketCard({super.key, required this.ticket});

  final UpcomingTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.raisedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(ticket: ticket),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 14,
              children: [
                _SeatBox(ticket: ticket),
                TicketInfoRow(
                  icon: Icons.event_rounded,
                  iconColor: AppColors.primary,
                  title: ticket.event.schedule,
                  subtitle: ticket.event.className,
                ),
                TicketInfoRow(
                  icon: Icons.location_on_rounded,
                  iconColor: AppColors.onPink,
                  title: ticket.event.venue,
                  subtitle: ticket.event.address,
                ),
                if (ticket.event.latitude != null &&
                    ticket.event.longitude != null)
                  VenueMapPreview(
                    latitude: ticket.event.latitude!,
                    longitude: ticket.event.longitude!,
                  ),
                FilledButton.icon(
                  onPressed: () => _openTicketNavigation(context, ticket),
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: const Text('Buka navigasi'),
                ),
                BirdStrip(bird: ticket.bird, category: ticket.category),
              ],
            ),
          ),
          const TicketPerforation(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Actions(code: ticket.code),
          ),
        ],
      ),
    );
  }
}

/// Membuka aplikasi peta native untuk navigasi ke venue tiket.
Future<void> _openTicketNavigation(
  BuildContext context,
  UpcomingTicket ticket,
) async {
  double? originLatitude;
  double? originLongitude;
  try {
    final position = await Geolocator.getCurrentPosition();
    originLatitude = position.latitude;
    originLongitude = position.longitude;
  } catch (_) {
    // Izin ditolak atau layanan lokasi tidak tersedia; lanjut tanpa origin.
  }

  final url = buildExternalNavigationUrl(
    originLatitude: originLatitude,
    originLongitude: originLongitude,
    destinationLatitude: ticket.event.latitude,
    destinationLongitude: ticket.event.longitude,
    destinationQuery: '${ticket.event.venue} ${ticket.event.address}',
  );
  if (url == null) {
    if (context.mounted) {
      showComingSoon(context);
    }
    return;
  }

  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else if (context.mounted) {
    showComingSoon(context);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.ticket});

  final UpcomingTicket ticket;

  static const double _iconCircle = 32;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lavenderTintStart, AppColors.lavender],
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
                  Icons.emoji_events_rounded,
                  size: 18,
                  color: AppColors.surface,
                ),
              ),
              Flexible(child: _EventTitle(ticket: ticket)),
            ],
          ),
          PulseBadge(
            label: '${TicketsStrings.readyPrefix} (${ticket.countdown})',
            backgroundColor: AppColors.lime,
            accentColor: AppColors.onLime,
          ),
        ],
      ),
    );
  }
}

class _EventTitle extends StatelessWidget {
  const _EventTitle({required this.ticket});

  final UpcomingTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ticket.event.series.toUpperCase(),
          style: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
        ),
        Text(ticket.event.title, style: AppTextStyles.title),
      ],
    );
  }
}

class _SeatBox extends StatelessWidget {
  const _SeatBox({required this.ticket});

  final UpcomingTicket ticket;

  static const double _sessionBox = 52;

  @override
  Widget build(BuildContext context) {
    final seat = ticket.seat;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lavenderTintStart,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(TicketsStrings.seatLabel, style: AppTextStyles.eyebrow),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      seat.number,
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    TicketChip(
                      label: seat.label,
                      background: AppColors.lavender,
                      foreground: AppColors.primary,
                    ),
                  ],
                ),
                Text(
                  seat.position,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Container(
            width: _sessionBox,
            height: _sessionBox,
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TicketsStrings.sessionLabel,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  seat.session,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    void comingSoon() => showComingSoon(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.lavenderTintStart,
            borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  const Icon(
                    Icons.qr_code_2_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  Text(
                    code,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              Text(
                TicketsStrings.readyToScan,
                style: AppTextStyles.label.copyWith(color: AppColors.onLime),
              ),
            ],
          ),
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                onPressed: comingSoon,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 19),
                label: const Text(
                  TicketsStrings.openQr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: TextButton.icon(
                onPressed: comingSoon,
                style:
                    AppTheme.softPillButton(
                      foreground: AppColors.primary,
                      textStyle: AppTextStyles.label,
                    ).copyWith(
                      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
                    ),
                icon: const Icon(Icons.map_rounded, size: 18),
                label: const Text(
                  TicketsStrings.paddockMap,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
