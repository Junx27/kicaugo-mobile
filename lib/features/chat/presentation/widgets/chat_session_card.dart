import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../domain/entities/chat_session.dart';
import '../chat_strings.dart';

/// Kartu satu sesi chat di daftar Pesan.
class ChatSessionCard extends StatelessWidget {
  const ChatSessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  final ChatSession session;
  final VoidCallback onTap;

  static const double _avatarSize = 48;
  static const PastelTone _indigoTone = PastelTone(
    light: AppColors.lavenderTintStart,
    strong: AppColors.lavender,
    foreground: AppColors.primary,
  );

  @override
  Widget build(BuildContext context) {
    final tone = _avatarTone(session.avatar);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.panelRadius),
      elevation: 1,
      shadowColor: AppColors.shadow,
      child: InkWell(
        key: Key('chat_session_${session.id}'),
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            spacing: 14,
            children: [
              _Avatar(
                avatar: session.avatar,
                tone: tone,
                online: session.online,
                verified: session.verified,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Text(
                            session.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          session.time,
                          style: AppTextStyles.caption.copyWith(
                            color: session.unread > 0
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        _CategoryBadge(
                          label: _badgeLabel(session),
                          tone: _badgeTone(session),
                        ),
                        if (session.online)
                          Text(
                            ChatStrings.online,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.onLime,
                            ),
                          ),
                        if (session.members != null)
                          Expanded(
                            child: Text(
                              session.members!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Text(
                            session.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption,
                          ),
                        ),
                        if (session.unread > 0)
                          _UnreadBadge(count: session.unread),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _icon(ChatAvatar avatar) => switch (avatar) {
    ChatAvatar.trophy => Icons.emoji_events_rounded,
    ChatAvatar.agent => Icons.support_agent_rounded,
    ChatAvatar.group => Icons.groups_rounded,
    ChatAvatar.bird => Icons.flutter_dash,
    ChatAvatar.support => Icons.headset_mic_rounded,
    ChatAvatar.forum => Icons.forum_rounded,
  };

  static PastelTone _avatarTone(ChatAvatar avatar) => switch (avatar) {
    ChatAvatar.trophy || ChatAvatar.agent || ChatAvatar.forum => _indigoTone,
    ChatAvatar.group || ChatAvatar.bird => AppTones.lime,
    ChatAvatar.support => AppTones.pink,
  };

  static PastelTone _badgeTone(ChatSession session) =>
      switch (session.category) {
        ChatCategory.organizer => session.support ? AppTones.pink : _indigoTone,
        ChatCategory.community => AppTones.lime,
      };

  static String _badgeLabel(ChatSession session) {
    if (session.support) return ChatStrings.badgeSupport;
    return switch (session.category) {
      ChatCategory.organizer => ChatStrings.badgeOrganizer,
      ChatCategory.community => ChatStrings.badgeCommunity,
    };
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.avatar,
    required this.tone,
    required this.online,
    required this.verified,
  });

  final ChatAvatar avatar;
  final PastelTone tone;
  final bool online;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: ChatSessionCard._avatarSize,
          height: ChatSessionCard._avatarSize,
          decoration: BoxDecoration(
            color: tone.light,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
          child: Icon(
            ChatSessionCard._icon(avatar),
            size: 24,
            color: tone.foreground,
          ),
        ),
        if (verified)
          const Positioned(
            right: -4,
            bottom: -4,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.surface,
              child: Icon(
                Icons.verified_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        if (online)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.limeStrong,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label, required this.tone});

  final String label;
  final PastelTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tone.light,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: tone.foreground),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: AppTextStyles.caption.copyWith(color: AppColors.surface),
        ),
      ),
    );
  }
}
