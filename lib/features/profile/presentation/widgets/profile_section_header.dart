import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// Judul section Profil dengan subjudul dan aksi opsional.
class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(title, style: AppTextStyles.title),
              if (subtitle != null)
                Text(subtitle!, style: AppTextStyles.caption),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
