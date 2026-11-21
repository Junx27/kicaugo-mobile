import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../domain/entities/community_post.dart';
import '../community_strings.dart';
import 'number_format.dart';

/// Status suka postingan yang ditampilkan.
typedef LikeView = ({bool liked, int count});

/// Kartu satu obrolan: penulis, hashtag, isi, galeri opsional, aksi.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.like,
    required this.onToggleLike,
  });

  final CommunityPost post;
  final LikeView like;
  final VoidCallback onToggleLike;

  @override
  Widget build(BuildContext context) {
    final showcase = post.hasShowcase;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: showcase
            ? AppColors.pink.withValues(alpha: 0.45)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _AuthorRow(author: post.author, accent: showcase),
          _Hashtag(text: post.hashtag),
          Text(post.body, style: AppTextStyles.body.copyWith(height: 1.6)),
          if (showcase) const _ShowcaseGallery(),
          _ActionBar(
            replies: post.counts.replies,
            like: like,
            onToggleLike: onToggleLike,
          ),
        ],
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.author, required this.accent});

  final PostAuthor author;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        InitialsAvatar(
          initials: author.initials,
          color: accent ? AppColors.onPink : AppColors.primary,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    author.name,
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                    ),
                    child: Text(
                      author.tag,
                      style: AppTextStyles.eyebrow.copyWith(
                        color: accent ? AppColors.onPink : AppColors.primary,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              Text(author.meta, style: AppTextStyles.caption),
            ],
          ),
        ),
        IconButton(
          tooltip: CommunityStrings.moreTooltip,
          onPressed: () => showComingSoon(context),
          icon: const Icon(Icons.more_vert_rounded, size: 20),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _Hashtag extends StatelessWidget {
  const _Hashtag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lavenderDeepGlow,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        text,
        style: AppTextStyles.eyebrow.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

/// Dua ubin pengganti foto: burung juara dan trofi dengan label "Juara 1".
class _ShowcaseGallery extends StatelessWidget {
  const _ShowcaseGallery();

  static const double _height = 140;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: SizedBox(
        height: _height,
        child: Row(
          spacing: 8,
          children: [
            const Expanded(
              child: ColoredBox(
                color: AppColors.lavender,
                child: Center(
                  child: Icon(
                    Icons.flutter_dash,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: AppColors.yellow,
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 56,
                        color: AppColors.onYellow,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(
                            AppTheme.pillRadius,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          children: [
                            const Icon(
                              Icons.military_tech_rounded,
                              size: 14,
                              color: AppColors.surface,
                            ),
                            Text(
                              CommunityStrings.champion,
                              style: AppTextStyles.eyebrow.copyWith(
                                color: AppColors.surface,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.replies,
    required this.like,
    required this.onToggleLike,
  });

  final int replies;
  final LikeView like;
  final VoidCallback onToggleLike;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          label:
              '${formatThousands(replies)} ${CommunityStrings.repliesSuffix}',
          onPressed: () => showComingSoon(context),
        ),
        _ActionButton(
          icon: like.liked
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          label:
              '${formatThousands(like.count)} ${CommunityStrings.likesSuffix}',
          color: like.liked ? AppColors.onPink : AppColors.textSecondary,
          onPressed: onToggleLike,
        ),
        _ActionButton(
          icon: Icons.share_rounded,
          label: CommunityStrings.share,
          onPressed: () => showComingSoon(context),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: AppTextStyles.label,
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
