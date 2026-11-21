import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../community_strings.dart';

/// Tombol mengambang untuk membuat postingan (belum tersedia).
class CreatePostFab extends StatelessWidget {
  const CreatePostFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => showComingSoon(context),
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 6,
        shadowColor: AppColors.primaryFocus,
        textStyle: AppTextStyles.button,
      ),
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text(CommunityStrings.createPost),
    );
  }
}
