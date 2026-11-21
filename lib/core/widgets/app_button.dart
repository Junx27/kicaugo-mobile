import 'package:flutter/material.dart';

/// Varian visual [AppButton].
enum AppButtonVariant { primary, outlined }

/// Tombol lebar penuh dengan state loading.
///
/// Tinggi, radius, warna, dan tipografi diambil dari [ThemeData] sehingga
/// widget ini tidak menyimpan token desain sendiri.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;

  /// Ikon opsional di kanan label (mis. panah lanjut).
  final IconData? trailingIcon;

  static const double _iconSize = 20;

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context),
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(context),
      ),
    };
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildChild(BuildContext context) {
    if (!isLoading) {
      return _buildLabel();
    }
    final colorScheme = Theme.of(context).colorScheme;
    final color = variant == AppButtonVariant.primary
        ? colorScheme.onPrimary
        : colorScheme.primary;
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }

  Widget _buildLabel() {
    if (trailingIcon == null) {
      return Text(label);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(label),
        Icon(trailingIcon, size: _iconSize),
      ],
    );
  }
}
