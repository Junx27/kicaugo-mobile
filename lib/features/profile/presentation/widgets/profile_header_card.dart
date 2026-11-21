import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/glow_orb.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../domain/entities/profile_content.dart';
import '../profile_strings.dart';
import 'profile_soft_button.dart';

/// Kartu identitas anggota: avatar, badge verified, klub, QR, dan aksi.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.member,
    required this.name,
  });

  final ProfileMember member;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -48,
            right: -48,
            child: GlowOrb(size: 144, color: AppColors.lavender, alpha: 0.6),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                _IdentityRow(member: member, name: name),
                const _HeaderActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({required this.member, required this.name});

  final ProfileMember member;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _MemberAvatar(member: member),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (member.isVerified) ...[
                    const SizedBox(width: 6),
                    const _VerifiedChip(),
                  ],
                ],
              ),
              _MemberMeta(member: member),
              Text(
                member.memberSince,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const _QrButton(),
      ],
    );
  }
}

class _MemberMeta extends StatelessWidget {
  const _MemberMeta({required this.member});

  final ProfileMember member;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          member.club,
          style: AppTextStyles.label.copyWith(color: AppColors.primary),
        ),
        Text(ProfileStrings.separator, style: AppTextStyles.caption),
        Text(member.memberId, style: AppTextStyles.caption),
      ],
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.member});

  final ProfileMember member;

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            child: SizedBox.expand(child: RemoteImage(url: member.avatarUrl)),
          ),
          if (member.isVerified)
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.softShadow,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  size: 14,
                  color: AppColors.surface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTones.lime.light,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 3,
        children: [
          Icon(Icons.shield_rounded, size: 12, color: AppTones.lime.foreground),
          Text(
            ProfileStrings.verified,
            style: AppTextStyles.eyebrow.copyWith(
              color: AppTones.lime.foreground,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrButton extends StatelessWidget {
  const _QrButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('profile_qr'),
      tooltip: ProfileStrings.qrTooltip,
      onPressed: () => showComingSoon(context),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surfaceLavender,
        foregroundColor: AppColors.primary,
        minimumSize: const Size(44, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
      ),
      icon: const Icon(Icons.qr_code_2_rounded, size: 22),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: ProfileSoftButton(
            key: const Key('profile_edit'),
            label: ProfileStrings.editProfile,
            icon: Icons.edit_outlined,
            onPressed: () => showComingSoon(context),
          ),
        ),
        Expanded(
          child: ProfileSoftButton(
            key: const Key('profile_share'),
            label: ProfileStrings.shareCard,
            icon: Icons.share_outlined,
            backgroundColor: AppColors.surfaceLavender,
            foregroundColor: AppColors.textPrimary,
            onPressed: () => showComingSoon(context),
          ),
        ),
      ],
    );
  }
}
