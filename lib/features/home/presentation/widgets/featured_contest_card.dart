import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/navigation_url_builder.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../../domain/entities/featured_contest.dart';
import '../home_strings.dart';
import 'venue_map_preview.dart';

/// Kartu kuning "Lomba Terdekat" dengan info hadiah, slot, dan peserta.
class FeaturedContestCard extends StatelessWidget {
  const FeaturedContestCard({super.key, required this.contest});

  final FeaturedContest contest;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppTones.yellow.gradient,
        borderRadius: BorderRadius.circular(AppTheme.showcaseRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: Icon(
              Icons.military_tech_rounded,
              size: 144,
              color: AppColors.textPrimary.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                _Header(distance: contest.distance),
                Text(contest.title, style: AppTextStyles.headlineSmall),
                _IconLine(
                  icon: Icons.location_on_rounded,
                  text: contest.schedule,
                ),
                if (contest.latitude != null && contest.longitude != null)
                  VenueMapPreview(
                    latitude: contest.latitude!,
                    longitude: contest.longitude!,
                  ),
                FilledButton.icon(
                  onPressed: () => _openNavigation(context, contest),
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: const Text('Buka navigasi'),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.payments_rounded,
                        label: HomeStrings.totalPrize,
                        value: contest.prize,
                      ),
                    ),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.grid_view_rounded,
                        label: HomeStrings.availableSlots,
                        value: contest.slots,
                        valueColor: AppColors.onLime,
                      ),
                    ),
                  ],
                ),
                _Footer(attendees: contest.attendees),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.distance});

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                const Icon(
                  Icons.near_me_rounded,
                  size: 13,
                  color: AppColors.yellow,
                ),
                Flexible(
                  child: Text(
                    '${HomeStrings.nearestPrefix} $distance',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const IconPill(label: HomeStrings.mainCategory, backgroundAlpha: 0.7),
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        Icon(icon, size: 16, color: AppColors.textPrimary),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.eyebrow.copyWith(letterSpacing: 0),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.button.copyWith(
                    color: valueColor,
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

class _Footer extends StatelessWidget {
  const _Footer({required this.attendees});

  final Attendees attendees;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            _AttendeeStack(attendees: attendees),
            Text(
              HomeStrings.confirmed,
              style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        FilledButton(
          onPressed: () => showComingSoon(context),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 18),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Text(HomeStrings.seeDetail),
              Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

/// Membuka aplikasi peta native untuk navigasi ke venue lomba.
Future<void> _openNavigation(
  BuildContext context,
  FeaturedContest contest,
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
    destinationLatitude: contest.latitude,
    destinationLongitude: contest.longitude,
    destinationQuery: contest.schedule,
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

/// Avatar inisial yang saling tumpuk ditambah jumlah peserta lain.
class _AttendeeStack extends StatelessWidget {
  const _AttendeeStack({required this.attendees});

  final Attendees attendees;

  static const double _size = 26;
  static const double _step = 18;
  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.onLime,
    AppColors.onPink,
  ];

  @override
  Widget build(BuildContext context) {
    final labels = [...attendees.initials, '+${attendees.others}'];
    return SizedBox(
      width: _step * (labels.length - 1) + _size,
      height: _size,
      child: Stack(
        children: [
          for (var index = 0; index < labels.length; index++)
            Positioned(
              left: _step * index,
              child: Container(
                width: _size,
                height: _size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _colors[index % _colors.length],
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
                child: Text(
                  labels[index],
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.surface,
                    letterSpacing: 0,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
