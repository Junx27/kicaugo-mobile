import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

/// Placeholder halaman yang belum tersedia.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    required this.title,
    required this.icon,
    this.footer,
  });

  final String title;
  final IconData icon;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.headlineSmall),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: AppTheme.splashLogoSize,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppTheme.itemSpacing),
                    Text(
                      AppConstants.comingSoon,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: AppTheme.sectionSpacing),
                      footer!,
                    ],
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
