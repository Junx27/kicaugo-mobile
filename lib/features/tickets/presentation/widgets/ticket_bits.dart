import 'package:flutter/material.dart';

import '../../../../core/entities/bird_category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/bird_category_style.dart';
import '../../domain/entities/ticket_parts.dart';
import '../tickets_strings.dart';

/// Chip kecil berlatar warna dengan ikon opsional (status/hasil tiket).
class TicketChip extends StatelessWidget {
  const TicketChip({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (icon != null) Icon(icon, size: 14, color: foreground),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.eyebrow.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Baris ikon + judul + keterangan (jadwal, lokasi).
class TicketInfoRow extends StatelessWidget {
  const TicketInfoRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Icon(icon, size: 19, color: iconColor),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

/// Strip data burung peserta (nama, ras, ring, pemilik).
class BirdStrip extends StatelessWidget {
  const BirdStrip({
    super.key,
    required this.bird,
    required this.category,
    this.trailing,
    this.showOwner = true,
  });

  final TicketBird bird;
  final BirdCategory category;
  final Widget? trailing;
  final bool showOwner;

  static const double _iconBox = 44;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lavenderGlow,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: _iconBox,
            height: _iconBox,
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
            ),
            child: Icon(category.icon, color: AppColors.primary),
          ),
          Expanded(
            child: _BirdText(bird: bird, showOwner: showOwner),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _BirdText extends StatelessWidget {
  const _BirdText({required this.bird, required this.showOwner});

  final TicketBird bird;
  final bool showOwner;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          children: [
            Flexible(
              child: Text(
                bird.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const TicketChip(
              label: TicketsStrings.originalRing,
              background: AppColors.lime,
              foreground: AppColors.onLime,
            ),
          ],
        ),
        Text(
          '${bird.breed} • ${bird.ring}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption,
        ),
        if (showOwner)
          Text(
            bird.owner,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.eyebrow.copyWith(letterSpacing: 0),
          ),
      ],
    );
  }
}

/// Garis sobekan tiket: takik setengah lingkaran di kedua sisi + garis putus.
class TicketPerforation extends StatelessWidget {
  const TicketPerforation({super.key});

  static const double _notchWidth = 10;
  static const double _notchHeight = 20;
  static const double _dash = 6;
  static const double _gap = 4;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _Notch(isLeft: true),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = (constraints.maxWidth / (_dash + _gap)).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var index = 0; index < count; index++)
                    Container(width: _dash, height: 2, color: AppColors.border),
                ],
              );
            },
          ),
        ),
        const _Notch(isLeft: false),
      ],
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch({required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(TicketPerforation._notchWidth);
    return Container(
      width: TicketPerforation._notchWidth,
      height: TicketPerforation._notchHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: isLeft
            ? const BorderRadius.horizontal(right: radius)
            : const BorderRadius.horizontal(left: radius),
      ),
    );
  }
}
