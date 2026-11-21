import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../chat_strings.dart';

/// Tombol tulis pesan baru (belum tersedia).
class ChatComposeButton extends StatelessWidget {
  const ChatComposeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: AppColors.primaryFocus,
      child: IconButton(
        key: const Key('chat_compose'),
        tooltip: ChatStrings.composeTooltip,
        icon: const Icon(
          Icons.edit_rounded,
          color: AppColors.surface,
          size: 20,
        ),
        onPressed: () => showComingSoon(context),
      ),
    );
  }
}
