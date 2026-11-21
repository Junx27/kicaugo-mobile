import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/link_button.dart';
import '../../domain/entities/community_post.dart';
import '../community_strings.dart';
import 'post_card.dart';

/// Bagian "Obrolan Terbaru": daftar postingan atau keadaan kosong.
class PostFeed extends StatelessWidget {
  const PostFeed({
    super.key,
    required this.posts,
    required this.likeOf,
    required this.onToggleLike,
  });

  final List<CommunityPost> posts;
  final LikeView Function(CommunityPost post) likeOf;
  final ValueChanged<CommunityPost> onToggleLike;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                CommunityStrings.feedTitle,
                style: AppTextStyles.headlineSmall,
              ),
            ),
            LinkButton(
              label: CommunityStrings.filter,
              trailingIcon: Icons.tune_rounded,
              style: AppTextStyles.label,
              onPressed: () => showComingSoon(context),
            ),
          ],
        ),
        if (posts.isEmpty)
          const _EmptyFeed()
        else
          for (final post in posts)
            PostCard(
              post: post,
              like: likeOf(post),
              onToggleLike: () => onToggleLike(post),
            ),
      ],
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

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
          const Icon(Icons.forum_outlined, color: AppColors.primary),
          Text(
            CommunityStrings.emptyFeed,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
