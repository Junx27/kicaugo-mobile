import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Ikon opsional sebuah chip beserta warnanya saat tidak terpilih.
typedef ChipIcon = ({IconData icon, Color color});

/// Pita chip pilihan tunggal yang bisa digulir mendatar.
class ScheduleChipRow<T> extends StatelessWidget {
  const ScheduleChipRow({
    super.key,
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.iconOf,
  });

  final List<T> items;
  final T selected;
  final String Function(T item) labelOf;
  final ValueChanged<T> onSelected;
  final ChipIcon? Function(T item)? iconOf;

  static const double _height = 38;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return _Chip(
            label: labelOf(item),
            icon: iconOf?.call(item),
            isSelected: item == selected,
            onTap: () => onSelected(item),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final ChipIcon? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? AppColors.surface : AppColors.textSecondary;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? AppColors.primary : AppColors.surface,
        shape: const StadiumBorder(),
        elevation: isSelected ? 0 : 1,
        shadowColor: AppColors.shadow,
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                if (icon != null)
                  Icon(
                    icon!.icon,
                    size: 16,
                    color: isSelected ? AppColors.surface : icon!.color,
                  ),
                Text(
                  label,
                  style: AppTextStyles.label.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
