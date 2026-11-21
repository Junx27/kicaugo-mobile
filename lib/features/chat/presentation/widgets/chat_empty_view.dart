import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../chat_strings.dart';

/// Tampilan saat pencarian/filter tidak cocok dengan sesi mana pun.
class ChatEmptyView extends StatelessWidget {
  const ChatEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('chat_empty_state'),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.lavenderTintStart,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      ),
      child: Column(
        spacing: 8,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 48,
            color: AppColors.primary,
          ),
          Text(ChatStrings.emptyTitle, style: AppTextStyles.title),
          Text(
            ChatStrings.emptyHint,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
