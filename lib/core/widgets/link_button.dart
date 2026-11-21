import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Tautan teks indigo tanpa padding (mis. "Lupa Kata Sandi?").
class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.style,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback onPressed;
  final TextStyle style;

  /// Ikon opsional di kanan label (mis. panah).
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: style,
      ),
      child: trailingIcon == null
          ? Text(label)
          : Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [Text(label), Icon(trailingIcon, size: 16)],
            ),
    );
  }
}
