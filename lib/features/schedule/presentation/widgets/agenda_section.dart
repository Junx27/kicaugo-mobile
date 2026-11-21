import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/link_button.dart';
import '../../domain/entities/agenda.dart';
import '../schedule_strings.dart';
import 'agenda_card.dart';

/// Bagian "Daftar Agenda Terdekat" berisi kartu agenda atau keadaan kosong.
class AgendaSection extends StatelessWidget {
  const AgendaSection({super.key, required this.agendas});

  final List<Agenda> agendas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(ScheduleStrings.agendaTitle, style: AppTextStyles.title),
                  _CountChip(count: agendas.length),
                ],
              ),
            ),
            LinkButton(
              label: ScheduleStrings.filterOrganizer,
              trailingIcon: Icons.expand_more_rounded,
              style: AppTextStyles.label,
              onPressed: () => showComingSoon(context),
            ),
          ],
        ),
        if (agendas.isEmpty)
          const _EmptyAgenda()
        else
          for (final agenda in agendas) AgendaCard(agenda: agenda),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        '$count ${ScheduleStrings.readySuffix}',
        style: AppTextStyles.eyebrow.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyAgenda extends StatelessWidget {
  const _EmptyAgenda();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      child: Column(
        spacing: 8,
        children: [
          const Icon(Icons.event_busy_rounded, color: AppColors.primary),
          Text(
            ScheduleStrings.emptyAgenda,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
