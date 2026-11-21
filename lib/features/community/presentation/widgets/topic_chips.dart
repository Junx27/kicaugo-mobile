import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/community_topic.dart';
import 'topic_style.dart';

/// Pita chip topik yang bisa digulir mendatar.
class TopicChips extends StatelessWidget {
  const TopicChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final CommunityTopic selected;
  final ValueChanged<CommunityTopic> onSelected;

  static const double _height = 38;

  @override
  Widget build(BuildContext context) {
    const topics = CommunityTopic.values;
    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: topics.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final topic = topics[index];
          final isSelected = topic == selected;
          return Material(
            color: isSelected ? AppColors.primary : AppColors.lavender,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => onSelected(topic),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    topic.label,
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
}
