import 'package:flutter/material.dart';

import '../../../../core/router/venue_map_args.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/external_navigation.dart';
import '../../../../core/widgets/icon_pill.dart';
import '../../../event/domain/entities/featured_contest.dart';
import '../../../event/presentation/event_detail_navigation.dart';
import '../home_strings.dart';
import 'venue_map_preview.dart';

/// Kartu kuning "Lomba Terdekat": peta di atas, badge di bawahnya, lalu detail lomba.
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FeaturedMap(contest: contest),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    _Header(distance: contest.distance, contest: contest),
                    _TitleRow(contest: contest),
                    _IconLine(
                      icon: Icons.location_on_rounded,
                      text: contest.schedule,
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
                    _NavigationButton(contest: contest),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Peta venue yang menempel di tepi atas kartu sebelum baris badge.
class _FeaturedMap extends StatelessWidget {
  const _FeaturedMap({required this.contest});

  final FeaturedContest contest;

  @override
  Widget build(BuildContext context) {
    final latitude = contest.latitude;
    final longitude = contest.longitude;
    if (latitude == null || longitude == null) {
      return const SizedBox.shrink();
    }

    return VenueMapPreview(
      latitude: latitude,
      longitude: longitude,
      options: VenueMapOptions(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.showcaseRadius),
          topRight: Radius.circular(AppTheme.showcaseRadius),
        ),
        onTap: () => pushVenueMap(
          context,
          VenueMapArgs(
            latitude: latitude,
            longitude: longitude,
            title: contest.title,
            address: contest.schedule,
            schedule: contest.schedule,
            distance: contest.distance,
          ),
        ),
      ),
    );
  }
}

/// Tombol navigasi eksternal yang selalu jadi elemen terakhir kartu.
class _NavigationButton extends StatelessWidget {
  const _NavigationButton({required this.contest});

  final FeaturedContest contest;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => openExternalNavigation(
        context: context,
        destinationLatitude: contest.latitude,
        destinationLongitude: contest.longitude,
        destinationQuery: contest.schedule,
      ),
      icon: const Icon(Icons.directions_rounded, size: 18),
      label: const Text(HomeStrings.openNavigation),
    );
  }
}

/// Baris badge: TERDEKAT di kiri, Lihat Detail di kanan.
class _Header extends StatelessWidget {
  const _Header({required this.distance, required this.contest});

  final String distance;
  final FeaturedContest contest;

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
        _DetailLink(contest: contest),
      ],
    );
  }
}

/// Judul lomba sebaris dengan avatar peserta di sebelah kanannya.
class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.contest});

  final FeaturedContest contest;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(contest.title, style: AppTextStyles.headlineSmall),
        ),
        _AttendeeStack(attendees: contest.attendees),
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

/// Badge "Lihat Detail" di header, menggantikan Kategori Utama.
class _DetailLink extends StatelessWidget {
  const _DetailLink({required this.contest});

  final FeaturedContest contest;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('see_detail_link'),
      onTap: () => pushEventDetail(context, contest),
      child: const IconPill(
        label: HomeStrings.seeDetail,
        trailingIcon: Icons.arrow_forward_rounded,
        iconColor: AppColors.textPrimary,
        backgroundAlpha: 0.7,
      ),
    );
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
