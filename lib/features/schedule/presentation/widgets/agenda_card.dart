import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../../domain/entities/agenda.dart';
import '../schedule_format.dart';
import '../schedule_strings.dart';
import 'schedule_icon_text.dart';

/// Kartu satu agenda gantangan berwarna sesuai aksennya.
class AgendaCard extends StatelessWidget {
  const AgendaCard({super.key, required this.agenda});

  final Agenda agenda;

  @override
  Widget build(BuildContext context) {
    final tone = agenda.tags.accent.tone;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tone.light, AppColors.inputFill],
        ),
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        border: Border.all(color: tone.strong.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          _Heading(agenda: agenda, tone: tone),
          if (agenda.quota != null) _QuotaBox(quota: agenda.quota!),
          if (agenda.note != null) _NoteBox(note: agenda.note!, tone: tone),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              ScheduleIconText(
                icon: Icons.calendar_month_rounded,
                iconColor: tone.foreground,
                text: longDate(agenda.slot.date),
              ),
              ScheduleIconText(
                icon: Icons.schedule_rounded,
                text: agenda.slot.time,
              ),
            ],
          ),
          ScheduleIconText(
            icon: Icons.location_on_rounded,
            iconColor: tone.foreground,
            text: agenda.slot.venue,
          ),
          Divider(color: AppColors.textPrimary.withValues(alpha: 0.06)),
          _Footer(offer: agenda.offer, tone: tone),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.agenda, required this.tone});

  final Agenda agenda;
  final PastelTone tone;

  static const double _badgeMaxWidth = 120;

  @override
  Widget build(BuildContext context) {
    final organizer = agenda.organizer;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        InitialsAvatar(
          initials: organizer.initials,
          size: 40,
          color: tone.foreground,
          radius: AppTheme.cardRadius,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    organizer.name.toUpperCase(),
                    style: AppTextStyles.eyebrow.copyWith(
                      color: tone.foreground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (organizer.tag != null) _TagChip(label: organizer.tag!),
                ],
              ),
              Text(
                agenda.title,
                style: AppTextStyles.cardTitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _badgeMaxWidth),
          child: _Badge(badge: agenda.tags.badge),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        label,
        style: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badge});

  final AgendaBadge badge;

  @override
  Widget build(BuildContext context) {
    final colors = badge.kind.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(badge.kind.icon, size: 10, color: colors.foreground),
          Flexible(
            child: Text(
              badge.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.eyebrow.copyWith(
                color: colors.foreground,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuotaBox extends StatelessWidget {
  const _QuotaBox({required this.quota});

  final AgendaQuota quota;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            children: [
              Text(ScheduleStrings.quotaLabel, style: AppTextStyles.caption),
              Text(
                '${quota.filledPercent}${ScheduleStrings.filledSuffix} '
                '(${ScheduleStrings.remainingPrefix} ${quota.remaining} '
                '${ScheduleStrings.ticketsSuffix})',
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          ProgressBar(value: quota.filledPercent / 100),
        ],
      ),
    );
  }
}

class _NoteBox extends StatelessWidget {
  const _NoteBox({required this.note, required this.tone});

  final String note;
  final PastelTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
      ),
      child: Row(
        spacing: 6,
        children: [
          Icon(Icons.military_tech_rounded, size: 15, color: tone.foreground),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.label.copyWith(color: tone.foreground),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.offer, required this.tone});

  final AgendaOffer offer;
  final PastelTone tone;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(offer.priceLabel, style: AppTextStyles.caption),
            Text(offer.price, style: AppTextStyles.title),
          ],
        ),
        TextButton(
          onPressed: () => showComingSoon(context),
          style: TextButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: tone.foreground,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            textStyle: AppTextStyles.label,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Text(offer.cta),
              const Icon(Icons.chevron_right_rounded, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
