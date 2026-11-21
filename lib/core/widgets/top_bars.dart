import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Tooltip avatar profil di semua bar atas tab utama.
const String profileTooltip = 'Profil';

/// Bar atas tab utama: logo + nama KicauGo, baris kecil [subtitle],
/// opsional [badge] di samping nama, lalu [actions] dan avatar profil.
class BrandTopBar extends StatelessWidget {
  const BrandTopBar({
    super.key,
    required this.subtitle,
    this.badge,
    this.actions = const [],
  });

  final Widget subtitle;
  final Widget? badge;
  final List<Widget> actions;

  static const double _logoSize = 36;

  @override
  Widget build(BuildContext context) {
    final brandStyle = AppTextStyles.title.copyWith(
      fontWeight: FontWeight.w800,
    );
    return _TopBarFrame(
      actions: actions,
      lead: Row(
        spacing: 8,
        children: [
          Container(
            width: _logoSize,
            height: _logoSize,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.lavender,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(AppConstants.mascotAsset),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    Flexible(
                      child: Text.rich(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          text: AppConstants.appNameLead,
                          children: [
                            TextSpan(
                              text: AppConstants.appNameAccent,
                              style: brandStyle.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        style: brandStyle,
                      ),
                    ),
                    ?badge,
                  ],
                ),
                subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bar atas bertajuk teks (mis. "Tiket Saya") dengan [actions] dan avatar.
class TitleTopBar extends StatelessWidget {
  const TitleTopBar({super.key, required this.title, this.actions = const []});

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return _TopBarFrame(
      actions: actions,
      lead: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.title,
      ),
    );
  }
}

class _TopBarFrame extends StatelessWidget {
  const _TopBarFrame({required this.lead, required this.actions});

  final Widget lead;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        spacing: 4,
        children: [
          Expanded(child: lead),
          ...actions,
          const SizedBox(width: 4),
          const ProfileAvatarButton(),
        ],
      ),
    );
  }
}

/// Tombol ikon bar atas, opsional titik merah muda sebagai penanda baru.
class TopBarIconButton extends StatelessWidget {
  const TopBarIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.showDot = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: showDot,
        smallSize: 8,
        backgroundColor: AppColors.onPink,
        child: Icon(icon),
      ),
    );
  }
}

/// Avatar bulat indigo yang membuka tab Profil.
class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({super.key});

  static const double _size = 32;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: profileTooltip,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.go(AppRoutes.profile),
        child: Container(
          width: _size,
          height: _size,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 18,
            color: AppColors.surface,
          ),
        ),
      ),
    );
  }
}
