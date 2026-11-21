import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/reminders_content.dart';
import '../reminders_strings.dart';

/// Pita pill filter burung. `selectedBirdId == null` berarti semua gacoan.
class ReminderBirdFilter extends StatelessWidget {
  const ReminderBirdFilter({
    super.key,
    required this.birds,
    required this.selectedBirdId,
    required this.onSelected,
  });

  final List<ReminderBird> birds;
  final String? selectedBirdId;
  final ValueChanged<String?> onSelected;

  static const double _height = 38;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: birds.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _BirdPill(
              key: const Key('reminders_bird_all'),
              label: RemindersStrings.allBirds,
              selected: selectedBirdId == null,
              onTap: () => onSelected(null),
            );
          }
          final bird = birds[index - 1];
          return _BirdPill(
            key: Key('reminders_bird_${bird.id}'),
            label: bird.filterLabel,
            selected: selectedBirdId == bird.id,
            onTap: () => onSelected(bird.id),
          );
        },
      ),
    );
  }
}

class _BirdPill extends StatelessWidget {
  const _BirdPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.surface : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
