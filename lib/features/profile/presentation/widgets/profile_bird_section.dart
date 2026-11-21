import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../domain/entities/profile_content.dart';
import '../profile_strings.dart';
import 'profile_section_header.dart';
import 'profile_soft_button.dart';

typedef _BirdStatusLook = ({
  String label,
  IconData icon,
  PastelTone tone,
  String action,
});

_BirdStatusLook _lookOf(ProfileBirdStatus status) => switch (status) {
  ProfileBirdStatus.ready => (
    label: ProfileStrings.birdStatusReady,
    icon: Icons.check_circle_rounded,
    tone: AppTones.lime,
    action: ProfileStrings.certificateAction,
  ),
  ProfileBirdStatus.molting => (
    label: ProfileStrings.birdStatusMolting,
    icon: Icons.hotel_rounded,
    tone: AppTones.pink,
    action: ProfileStrings.careAction,
  ),
  ProfileBirdStatus.training => (
    label: ProfileStrings.birdStatusTraining,
    icon: Icons.schedule_rounded,
    tone: AppTones.periwinkle,
    action: ProfileStrings.detailAction,
  ),
};

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.surface,
  borderRadius: BorderRadius.circular(AppTheme.panelRadius),
  boxShadow: AppTheme.softShadow,
);

/// Section Amunisi Gantangan: satu kartu hero dan kartu ringkas lainnya.
class ProfileBirdSection extends StatelessWidget {
  const ProfileBirdSection({super.key, required this.birds});

  final List<ProfileBird> birds;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        ProfileSectionHeader(
          title: ProfileStrings.birdsTitle,
          subtitle: ProfileStrings.birdsSubtitle(birds.length),
          trailing: ProfileSoftButton(
            key: const Key('profile_add_bird'),
            label: ProfileStrings.add,
            icon: Icons.add_rounded,
            expanded: false,
            onPressed: () => showComingSoon(context),
          ),
        ),
        for (final bird in birds)
          if (bird.isHero)
            _HeroBirdCard(bird: bird)
          else
            _CompactBirdCard(bird: bird),
      ],
    );
  }
}

class _HeroBirdCard extends StatelessWidget {
  const _HeroBirdCard({required this.bird});

  final ProfileBird bird;

  @override
  Widget build(BuildContext context) {
    final look = _lookOf(bird.status);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          _BirdIdentity(
            bird: bird,
            look: look,
            photoSize: 80,
            showHeroBadge: true,
          ),
          _HighlightBanner(text: bird.highlight),
          if (bird.careSlots.isNotEmpty) _CareCard(slots: bird.careSlots),
          ProfileSoftButton(
            label: look.action,
            icon: Icons.verified_user_outlined,
            onPressed: () => showComingSoon(context),
          ),
        ],
      ),
    );
  }
}

class _CompactBirdCard extends StatelessWidget {
  const _CompactBirdCard({required this.bird});

  final ProfileBird bird;

  @override
  Widget build(BuildContext context) {
    final look = _lookOf(bird.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          _BirdIdentity(bird: bird, look: look, photoSize: 64),
          Row(
            spacing: 8,
            children: [
              if (bird.footerNote != null)
                Expanded(
                  child: Row(
                    spacing: 4,
                    children: [
                      Icon(look.icon, size: 14, color: AppColors.textSecondary),
                      Expanded(
                        child: Text(
                          bird.footerNote!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ProfileSoftButton(
                label: look.action,
                expanded: false,
                backgroundColor: AppColors.surfaceLavender,
                onPressed: () => showComingSoon(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BirdIdentity extends StatelessWidget {
  const _BirdIdentity({
    required this.bird,
    required this.look,
    required this.photoSize,
    this.showHeroBadge = false,
  });

  final ProfileBird bird;
  final _BirdStatusLook look;
  final double photoSize;
  final bool showHeroBadge;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _BirdPhoto(
          url: bird.imageUrl,
          size: photoSize,
          showHeroBadge: showHeroBadge,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      bird.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _BirdStatusChip(look: look),
                ],
              ),
              Text(
                bird.species,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _RingLine(bird: bird),
            ],
          ),
        ),
      ],
    );
  }
}

class _BirdPhoto extends StatelessWidget {
  const _BirdPhoto({
    required this.url,
    required this.size,
    this.showHeroBadge = false,
  });

  final String url;
  final double size;
  final bool showHeroBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            child: SizedBox.expand(child: RemoteImage(url: url)),
          ),
          if (showHeroBadge)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Text(
                  ProfileStrings.heroBadge,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.surface,
                    fontSize: 9,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BirdStatusChip extends StatelessWidget {
  const _BirdStatusChip({required this.look});

  final _BirdStatusLook look;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: look.tone.light,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(look.icon, size: 12, color: look.tone.foreground),
          Text(
            look.label,
            style: AppTextStyles.eyebrow.copyWith(
              color: look.tone.foreground,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingLine extends StatelessWidget {
  const _RingLine({required this.bird});

  final ProfileBird bird;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _RingChip(ringId: bird.ringId),
        if (bird.isHero)
          const _VerifiedRing()
        else ...[
          Text(ProfileStrings.separator, style: AppTextStyles.caption),
          Text(
            bird.highlight,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _RingChip extends StatelessWidget {
  const _RingChip({required this.ringId});

  final String ringId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(AppTheme.badgeRadius),
      ),
      child: Text(
        ringId,
        style: AppTextStyles.eyebrow.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _VerifiedRing extends StatelessWidget {
  const _VerifiedRing();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 14,
          color: AppTones.lime.foreground,
        ),
        Text(
          ProfileStrings.ringVerified,
          style: AppTextStyles.eyebrow.copyWith(
            color: AppTones.lime.foreground,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _HighlightBanner extends StatelessWidget {
  const _HighlightBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  ProfileStrings.highlightLabel,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CareCard extends StatelessWidget {
  const _CareCard({required this.slots});

  final List<BirdCareSlot> slots;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lavenderGlow,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        spacing: 8,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  ProfileStrings.careTitle,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                ProfileStrings.careSummary,
                style: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              for (final slot in slots)
                Expanded(child: _CareSlotTile(slot: slot)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CareSlotTile extends StatelessWidget {
  const _CareSlotTile({required this.slot});

  final BirdCareSlot slot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
      ),
      child: Column(
        spacing: 2,
        children: [
          Text(
            slot.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            slot.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
