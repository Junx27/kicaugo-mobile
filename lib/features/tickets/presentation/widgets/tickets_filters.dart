import 'package:flutter/material.dart';

import '../../../../core/entities/bird_category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/bird_category_style.dart';
import '../cubit/tickets_state.dart';
import '../tickets_strings.dart';

/// Tab segmen (aktif/riwayat/dibatalkan) dengan jumlah tiket.
class TicketsTabs extends StatelessWidget {
  const TicketsTabs({
    super.key,
    required this.current,
    required this.countFor,
    required this.onSelected,
  });

  final TicketsTab current;
  final int Function(TicketsTab tab) countFor;
  final ValueChanged<TicketsTab> onSelected;

  static const Map<TicketsTab, (String, IconData)> _tabs = {
    TicketsTab.active: (
      TicketsStrings.tabActive,
      Icons.confirmation_number_rounded,
    ),
    TicketsTab.history: (TicketsStrings.tabHistory, Icons.history_rounded),
    TicketsTab.cancelled: (TicketsStrings.tabCancelled, Icons.cancel_rounded),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        spacing: 8,
        children: [
          for (final entry in _tabs.entries)
            _Pill(
              icon: entry.value.$2,
              label: '${entry.value.$1} (${countFor(entry.key)})',
              isSelected: entry.key == current,
              onTap: () => onSelected(entry.key),
            ),
        ],
      ),
    );
  }
}

/// Baris filter burung: "Filter:" lalu chip kategori yang relevan.
class BirdFilterRow extends StatelessWidget {
  const BirdFilterRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final BirdCategory selected;
  final ValueChanged<BirdCategory> onSelected;

  static const List<BirdCategory> _options = [
    BirdCategory.all,
    BirdCategory.muraiBatu,
    BirdCategory.kacer,
    BirdCategory.cucakHijau,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 6,
        children: [
          Text(TicketsStrings.filterLabel, style: AppTextStyles.caption),
          for (final category in _options)
            _Pill(
              label: category == BirdCategory.all
                  ? TicketsStrings.allBirds
                  : category.label,
              isSelected: category == selected,
              compact: true,
              onTap: () => onSelected(category),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.compact = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? AppColors.surface : AppColors.textSecondary;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? AppColors.primary : AppColors.surface,
        shape: const StadiumBorder(),
        elevation: isSelected ? 2 : 0.5,
        shadowColor: AppColors.shadow,
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16,
              vertical: compact ? 6 : 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                if (icon != null) Icon(icon, size: 17, color: foreground),
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

/// Keadaan kosong saat filter tidak cocok dengan tiket mana pun.
class TicketsEmptyView extends StatelessWidget {
  const TicketsEmptyView({super.key});

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
            TicketsStrings.emptyTickets,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
