import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../theme/app_colors.dart';

/// Satu tujuan di [PillNavBar].
@immutable
class PillNavItem {
  const PillNavItem({required this.icon, required this.label, this.badge});

  final IconData icon;
  final String label;

  /// Angka kecil di pojok ikon; tidak tampil bila `null` atau 0.
  final int? badge;
}

/// Navigasi bawah berbentuk pill putih mengambang.
class PillNavBar extends StatelessWidget {
  const PillNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<PillNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const double height = 64;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: LiquidGlassLayer(
          settings: const LiquidGlassSettings(
            thickness: 20,
            blur: 8,
            refractiveIndex: 1.5,
            glassColor: Color(0x1AFFFFFF),
          ),
          child: LiquidGlass(
            shape: const LiquidRoundedSuperellipse(borderRadius: 40),
            child: Container(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  for (var index = 0; index < items.length; index++)
                    Expanded(
                      child: _NavButton(
                        item: items[index],
                        isActive: index == currentIndex,
                        onTap: () => onSelected(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final PillNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.onLime : AppColors.textSecondary;
    final badge = item.badge ?? 0;
    return Semantics(
      selected: isActive,
      button: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            Badge(
              isLabelVisible: badge > 0,
              label: Text('$badge'),
              backgroundColor: AppColors.lime,
              textColor: AppColors.onLime,
              child: Icon(item.icon, size: 24, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
