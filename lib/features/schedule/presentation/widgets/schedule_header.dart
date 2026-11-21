import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../schedule_strings.dart';

/// Judul "Jadwal Lomba", chip bulan, tombol kalender, dan kolom cari.
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key, required this.monthLabel});

  final String monthLabel;

  static const double _calendarBox = 40;
  static const double _searchHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        ScheduleStrings.title,
                        style: AppTextStyles.headline,
                      ),
                      _MonthChip(label: monthLabel),
                    ],
                  ),
                  Text(ScheduleStrings.subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            IconButton(
              tooltip: ScheduleStrings.calendarTooltip,
              onPressed: () => showComingSoon(context),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.inputFill,
                fixedSize: const Size.square(_calendarBox),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
              ),
              icon: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        Material(
          color: AppColors.surface,
          elevation: 2,
          shadowColor: AppColors.shadow,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            onTap: () => showComingSoon(context),
            child: SizedBox(
              height: _searchHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    Expanded(
                      child: Text(
                        ScheduleStrings.searchHint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.tune_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthChip extends StatelessWidget {
  const _MonthChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        label,
        style: AppTextStyles.eyebrow.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
