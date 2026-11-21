import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Gambar jaringan dengan placeholder dan fallback yang aman saat offline.
class RemoteImage extends StatelessWidget {
  const RemoteImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return const _RemoteImagePlaceholder.loading();
      },
      errorBuilder: (context, error, stackTrace) {
        return const _RemoteImagePlaceholder.failed();
      },
    );
  }
}

class _RemoteImagePlaceholder extends StatelessWidget {
  const _RemoteImagePlaceholder.loading() : isLoading = true;

  const _RemoteImagePlaceholder.failed() : isLoading = false;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          isLoading ? Icons.image_outlined : Icons.image_not_supported_outlined,
          color: colorScheme.onSurfaceVariant,
          size: AppTheme.iconSize,
        ),
      ),
    );
  }
}
