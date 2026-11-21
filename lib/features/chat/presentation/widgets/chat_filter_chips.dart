import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../chat_strings.dart';
import '../cubit/chat_state.dart';

/// Pita filter: Semua / Panitia EO / Komunitas.
class ChatFilterChips extends StatelessWidget {
  const ChatFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ChatFilter selected;
  final ValueChanged<ChatFilter> onSelected;

  static const List<ChatFilter> _filters = <ChatFilter>[
    ChatFilter.all,
    ChatFilter.organizer,
    ChatFilter.community,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == selected;
          return Material(
            color: isSelected ? AppColors.primary : AppColors.lavender,
            shape: const StadiumBorder(),
            child: InkWell(
              key: Key('chat_filter_${filter.name}'),
              customBorder: const StadiumBorder(),
              onTap: () => onSelected(filter),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    _label(filter),
                    style: AppTextStyles.label.copyWith(
                      color: isSelected
                          ? AppColors.surface
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static String _label(ChatFilter filter) => switch (filter) {
    ChatFilter.all => ChatStrings.filterAll,
    ChatFilter.organizer => ChatStrings.filterOrganizer,
    ChatFilter.community => ChatStrings.filterCommunity,
  };
}
