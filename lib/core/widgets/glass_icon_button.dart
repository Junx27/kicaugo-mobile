import 'package:flutter/material.dart';

import 'glass_pill.dart';

/// Tombol ikon bulat dengan latar kaca cair, mengikuti gaya navbar bawah.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = 48,
  });

  /// Key dipasang pada [IconButton] agar tetap bisa ditargetkan widget test.
  final Key buttonKey;

  /// Widget ikon di dalam tombol; ukuran diatur oleh ikon itu sendiri.
  final Widget icon;
  final String tooltip;
  final VoidCallback onPressed;

  /// Diameter tombol.
  final double size;

  @override
  Widget build(BuildContext context) {
    return GlassPill(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        width: size,
        height: size,
        child: IconButton(
          key: buttonKey,
          tooltip: tooltip,
          constraints: BoxConstraints.tightFor(width: size, height: size),
          padding: EdgeInsets.zero,
          icon: icon,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
