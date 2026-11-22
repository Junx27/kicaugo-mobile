import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/bird_category_item.dart';
import '../home_strings.dart';

const Duration _chipSwapDuration = Duration(milliseconds: 250);
const double _chipHeight = 32;
const double _chipIconSize = 14;
const double _chipGap = 8;
const double _chipPadding = 12;

/// Pita chip kategori burung yang sumber datanya dari backend.
///
/// Kategori terpilih otomatis bergeser ke posisi kedua (setelah
/// "Semua Lomba") dengan animasi geser dari kanan.
class CategoryChips extends StatefulWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedName,
    required this.onSelected,
  });

  final List<BirdCategoryItem> categories;
  final String selectedName;
  final ValueChanged<String> onSelected;

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  late List<_Chip> _chips;
  late String _selectedName;

  @override
  void initState() {
    super.initState();
    _selectedName = widget.selectedName;
    _chips = _orderedChips(widget.selectedName);
  }

  @override
  void didUpdateWidget(covariant CategoryChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedName != widget.selectedName) {
      _reorder(widget.selectedName);
    } else if (!listEquals(oldWidget.categories, widget.categories)) {
      // Daftar baru butuh AnimatedList baru agar jumlah item sinkron.
      _listKey = GlobalKey<AnimatedListState>();
      _chips = _orderedChips(widget.selectedName);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Urutan awal: "Semua Lomba" diikuti kategori dari backend.
  List<_Chip> _baseChips() => <_Chip>[
    (name: HomeStrings.allCategories, icon: null),
    for (final category in widget.categories)
      (name: category.name, icon: category.icon),
  ];

  /// Menaruh kategori terpilih tepat setelah "Semua Lomba".
  List<_Chip> _orderedChips(String selectedName) {
    final base = _baseChips();
    if (selectedName == HomeStrings.allCategories) return base;
    final selected = base.where((chip) => chip.name == selectedName);
    if (selected.isEmpty) return base;
    return <_Chip>[
      base.first,
      selected.first,
      ...base.skip(1).where((chip) => chip.name != selectedName),
    ];
  }

  /// Memindahkan chip yang berubah posisi lewat remove + insert AnimatedList.
  void _reorder(String selectedName) {
    final next = _orderedChips(selectedName);
    final moved =
        _chips
            .where((chip) => next.indexOf(chip) != _chips.indexOf(chip))
            .toList()
          ..sort((a, b) => _chips.indexOf(b).compareTo(_chips.indexOf(a)));

    final listState = _listKey.currentState;
    for (final chip in moved) {
      final index = _chips.indexOf(chip);
      listState?.removeItem(
        index,
        (context, animation) =>
            _animatedChip(chip, context, animation, exiting: true),
        duration: _chipSwapDuration,
      );
      _chips.removeAt(index);
    }

    moved.sort((a, b) => next.indexOf(a).compareTo(next.indexOf(b)));
    for (final chip in moved) {
      final index = next.indexOf(chip);
      listState?.insertItem(index, duration: _chipSwapDuration);
      _chips.insert(index, chip);
    }

    setState(() => _selectedName = selectedName);
    _scrollToStart();
  }

  /// Mengembalikan pita ke pangkal agar chip terpilih terlihat di kiri.
  void _scrollToStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _chipHeight,
    child: AnimatedList(
      key: _listKey,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      initialItemCount: _chips.length,
      itemBuilder: (context, index, animation) => Padding(
        padding: const EdgeInsets.only(right: _chipGap),
        child: _animatedChip(_chips[index], context, animation),
      ),
    ),
  );

  Widget _animatedChip(
    _Chip chip,
    BuildContext context,
    Animation<double> animation, {
    bool exiting = false,
  }) {
    final offset = animation.drive(
      Tween<Offset>(
        begin: exiting ? Offset.zero : const Offset(1, 0),
        end: exiting ? const Offset(-1, 0) : Offset.zero,
      ),
    );
    final opacity = exiting
        ? animation.drive(Tween<double>(begin: 1, end: 0))
        : animation;
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: offset,
        child: _CategoryChip(
          name: chip.name,
          icon: chip.icon,
          isSelected: chip.name == _selectedName && !exiting,
          onTap: () => widget.onSelected(chip.name),
        ),
      ),
    );
  }
}

/// Data chip: record memberi equality nilai tanpa kelas tambahan.
typedef _Chip = ({String name, String? icon});

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? AppColors.surface : AppColors.textSecondary;
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        key: ValueKey<String>('category-chip-$name'),
        color: isSelected ? AppColors.primary : AppColors.lavenderGlow,
        elevation: isSelected ? 4 : 2,
        shadowColor: AppColors.shadow,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _chipPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                _ChipIcon(icon: icon),
                Text(
                  name,
                  style: AppTextStyles.chipLabel.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipIcon extends StatelessWidget {
  const _ChipIcon({required this.icon});

  final String? icon;

  @override
  Widget build(BuildContext context) {
    final asset = icon;
    if (asset == null) {
      return const Icon(
        Icons.local_fire_department_rounded,
        size: 13,
        color: AppColors.onYellow,
      );
    }
    return SvgPicture.asset(asset, width: _chipIconSize, height: _chipIconSize);
  }
}
