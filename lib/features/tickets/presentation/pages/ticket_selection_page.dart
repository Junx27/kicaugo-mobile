import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_glass.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_pill_bar.dart';
import '../../../../core/widgets/hideable_bottom_bar.dart';
import '../../../../core/widgets/liquid_top_bar_icon_button.dart';
import '../../data/datasources/fake_ticket_selection_data_source.dart';
import '../../domain/entities/ticket_selection_item.dart';
import '../ticket_selection_data.dart';

/// Halaman pemesanan tiket dan nomor gantangan untuk satu kelas/sesi.
///
/// Seluruh isi masih memakai data dummy; hanya gaya top bar dan pill bawah
/// yang mengikuti komponen kaca aplikasi.
class TicketSelectionPage extends StatefulWidget {
  const TicketSelectionPage({super.key, this.item});

  /// Kelas/sesi yang dipilih di halaman detail.
  final TicketSelectionItem? item;

  @override
  State<TicketSelectionPage> createState() => _TicketSelectionPageState();
}

class _TicketSelectionPageState extends State<TicketSelectionPage> {
  final ScrollController _scrollController = ScrollController();
  late final TicketSelectionItem _contestClass;
  late int _tierIndex;
  late String _seat;

  @override
  void initState() {
    super.initState();
    _contestClass = widget.item ?? FakeTicketSelectionDataSource.defaultItem;
    _tierIndex = _resolveTierIndex(_contestClass.price);
    _seat = TicketSelectionData.defaultSeat;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Memakai tier yang harganya sama dengan kelas, atau VIP sebagai default.
  int _resolveTierIndex(String price) {
    final index = TicketSelectionData.tiers.indexWhere(
      (tier) => tier.price == price,
    );
    if (index < 0) return TicketSelectionData.defaultTierIndex;
    return index;
  }

  void _selectTier(int index) => setState(() => _tierIndex = index);

  void _selectSeat(String seat) => setState(() => _seat = seat);

  @override
  Widget build(BuildContext context) {
    final tier = TicketSelectionData.tiers[_tierIndex];
    final viewPadding = MediaQuery.paddingOf(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: LiquidGlassLayer(
          settings: AppGlass.settings,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 60,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: LiquidTopBarIconButton(
                  icon: Icons.arrow_back_rounded,
                  semanticLabel: TicketSelectionStrings.back,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            title: SizedBox(
              width: double.infinity,
              height: LiquidTopBarIconButton.size,
              child: LiquidGlass(
                shape: const LiquidRoundedSuperellipse(
                  borderRadius: LiquidTopBarIconButton.size / 2,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.confirmation_number_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        Flexible(
                          child: Text(
                            TicketSelectionStrings.topBarTitle,
                            style: AppTextStyles.title.copyWith(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              top: viewPadding.top + kToolbarHeight - 12,
              bottom: 100 + viewPadding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _EventMiniBar(item: _contestClass),
                const SizedBox(height: 16),
                _TierSection(
                  tiers: TicketSelectionData.tiers,
                  selectedIndex: _tierIndex,
                  onSelected: _selectTier,
                ),
                const SizedBox(height: 8),
                _SeatMapSection(selectedSeat: _seat, onSelected: _selectSeat),
                const SizedBox(height: 16),
                _SelectionSummary(item: _contestClass, tier: tier, seat: _seat),
                const SizedBox(height: 16),
                const _RulesNote(),
              ],
            ),
          ),
          HideableBottomBar(
            controller: _scrollController,
            child: _BottomBar(tier: tier, seat: _seat),
          ),
        ],
      ),
    );
  }
}

class _EventMiniBar extends StatelessWidget {
  const _EventMiniBar({required this.item});

  final TicketSelectionItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLavender,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.lavenderDeepGlow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.military_tech_rounded,
                size: 22,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TicketSelectionStrings.eventEdition.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.6,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${item.name} • ${item.session}',
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  Text(
                    item.time,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TierSection extends StatelessWidget {
  const _TierSection({
    required this.tiers,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<TicketTier> tiers;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TicketSelectionStrings.chooseCategoryTitle,
                      style: AppTextStyles.title,
                    ),
                    Text(
                      TicketSelectionStrings.chooseCategorySubtitle,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lavenderDeepGlow,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Text(
                  '${tiers.length} ${TicketSelectionStrings.categoryCount}',
                  style: AppTextStyles.label.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          for (var index = 0; index < tiers.length; index++)
            _TierCard(
              tier: tiers[index],
              selected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  final TicketTier tier;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: selected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            _TierHeader(tier: tier, selected: selected),
            if (tier.perks.isNotEmpty) _TierPerks(perks: tier.perks),
            _TierPrice(tier: tier, selected: selected),
          ],
        ),
      ),
    );
  }
}

class _TierHeader extends StatelessWidget {
  const _TierHeader({required this.tier, required this.selected});

  final TicketTier tier;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.lavenderDeepGlow
                : AppColors.surfaceLavender,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(tier.icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tier.name, style: AppTextStyles.cardTitle),
              Text(tier.location, style: AppTextStyles.caption),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _badgeBackground(tier, selected),
            borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              if (selected)
                const Icon(Icons.check_rounded, size: 13, color: Colors.white),
              Text(
                tier.badge,
                style: AppTextStyles.label.copyWith(
                  color: _badgeForeground(tier, selected),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Color _badgeBackground(TicketTier tier, bool selected) {
  if (selected) return AppColors.primary;
  if (tier.badge == TicketSelectionStrings.favorite) return AppColors.lime;
  return AppColors.surfaceLavender;
}

Color _badgeForeground(TicketTier tier, bool selected) {
  if (selected) return Colors.white;
  if (tier.badge == TicketSelectionStrings.favorite) return AppColors.onLime;
  return AppColors.textSecondary;
}

class _TierPerks extends StatelessWidget {
  const _TierPerks({required this.perks});

  final List<String> perks;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < perks.length; index++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceLavender,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(
                  index == 0 ? Icons.visibility_rounded : Icons.badge_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                Text(perks[index], style: AppTextStyles.label),
              ],
            ),
          ),
      ],
    );
  }
}

class _TierPrice extends StatelessWidget {
  const _TierPrice({required this.tier, required this.selected});

  final TicketTier tier;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(tier.priceLabel, style: AppTextStyles.label)),
          Text(
            tier.price,
            style: AppTextStyles.cardTitle.copyWith(
              color: selected ? AppColors.primary : AppColors.textPrimary,
              fontSize: selected ? 17 : 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatMapSection extends StatelessWidget {
  const _SeatMapSection({required this.selectedSeat, required this.onSelected});

  final String selectedSeat;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final available =
        TicketSelectionData.seatCount -
        TicketSelectionData.bookedSeats.length -
        1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${TicketSelectionStrings.seatMapTitle} '
                    '(${TicketSelectionStrings.seatMapFormat})',
                    style: AppTextStyles.title,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLavender,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    TicketSelectionStrings.gridLabel,
                    style: AppTextStyles.label,
                  ),
                ),
              ],
            ),
            Text(
              TicketSelectionStrings.seatMapSubtitle,
              style: AppTextStyles.caption,
            ),
            const _StageMarker(),
            Column(
              mainAxisSize: MainAxisSize.min,
              // Jarak antara legend dan grid seat. Naikkan/turunkan sesuai selera.
              spacing: 12,
              children: [
                _Legend(available: available, selectedSeat: selectedSeat),
                _SeatGrid(selectedSeat: selectedSeat, onSelected: onSelected),
              ],
            ),
            const _ZoneGuide(),
          ],
        ),
      ),
    );
  }
}

class _StageMarker extends StatelessWidget {
  const _StageMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          Flexible(
            child: Text(
              TicketSelectionStrings.stageLabel.toUpperCase(),
              style: AppTextStyles.label.copyWith(letterSpacing: 0.6),
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(Icons.gavel_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.available, required this.selectedSeat});

  final int available;
  final String selectedSeat;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        _LegendItem(
          color: AppColors.lime,
          label: '${TicketSelectionStrings.available} ($available)',
        ),
        _LegendItem(
          color: AppColors.primary,
          label:
              '${TicketSelectionStrings.legendSelected} '
              '(${TicketSelectionStrings.seatPrefix}$selectedSeat)',
          foreground: AppColors.primary,
        ),
        _LegendItem(
          color: AppColors.pink,
          label:
              '${TicketSelectionStrings.legendBooked} '
              '(${TicketSelectionData.bookedSeats.length})',
          foreground: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.foreground = AppColors.textPrimary,
  });

  final Color color;
  final String label;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(label, style: AppTextStyles.label.copyWith(color: foreground)),
      ],
    );
  }
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({required this.selectedSeat, required this.onSelected});

  final String selectedSeat;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: TicketSelectionData.gridCount,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var number = 1; number <= TicketSelectionData.seatCount; number++)
          _SeatCell(
            number: number,
            selected: TicketSelectionData.formatSeat(number) == selectedSeat,
            booked: TicketSelectionData.bookedSeats.contains(number),
            onTap: () => onSelected(TicketSelectionData.formatSeat(number)),
          ),
      ],
    );
  }
}

class _SeatCell extends StatelessWidget {
  const _SeatCell({
    required this.number,
    required this.selected,
    required this.booked,
    required this.onTap,
  });

  final int number;
  final bool selected;
  final bool booked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = TicketSelectionData.formatSeat(number);
    final decoration = booked ? TextDecoration.lineThrough : null;
    return Semantics(
      button: !booked,
      enabled: !booked,
      selected: selected,
      label: 'Gantangan $label',
      child: InkWell(
        onTap: booked ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _seatBackground(selected: selected, booked: booked),
            borderRadius: BorderRadius.circular(12),
            border: selected ? null : Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'G',
                style: AppTextStyles.label.copyWith(
                  color: _seatForeground(selected: selected, booked: booked),
                  fontSize: 10,
                  decoration: decoration,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.cardTitle.copyWith(
                  color: _seatForeground(selected: selected, booked: booked),
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  decoration: decoration,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _seatBackground({required bool selected, required bool booked}) {
  if (booked) return AppColors.pink;
  if (selected) return AppColors.primary;
  return AppColors.surface;
}

Color _seatForeground({required bool selected, required bool booked}) {
  if (booked) return AppColors.onPink;
  if (selected) return Colors.white;
  return AppColors.textPrimary;
}

class _ZoneGuide extends StatelessWidget {
  const _ZoneGuide();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 8,
      runSpacing: 4,
      children: [
        Text(TicketSelectionStrings.zoneA, style: AppTextStyles.eyebrow),
        Text(TicketSelectionStrings.zoneB, style: AppTextStyles.eyebrow),
        Text(TicketSelectionStrings.zoneC, style: AppTextStyles.eyebrow),
      ],
    );
  }
}

class _SelectionSummary extends StatelessWidget {
  const _SelectionSummary({
    required this.item,
    required this.tier,
    required this.seat,
  });

  final TicketSelectionItem item;
  final TicketTier tier;
  final String seat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Row(
              spacing: 8,
              children: [
                const Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                Expanded(
                  child: Text(
                    TicketSelectionStrings.selectionTitle,
                    style: AppTextStyles.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            _SelectedSeatRow(tier: tier, seat: seat),
            _SummaryDetails(item: item),
          ],
        ),
      ),
    );
  }
}

class _SelectedSeatRow extends StatelessWidget {
  const _SelectedSeatRow({required this.tier, required this.seat});

  final TicketTier tier;
  final String seat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '${TicketSelectionStrings.seatPrefix}$seat',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${TicketSelectionStrings.selectedSeatPrefix}$seat',
                  style: AppTextStyles.body.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${tier.name} (${TicketSelectionStrings.legendSelected} '
                  '$seat)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
            ),
            child: Text(
              TicketSelectionStrings.locked,
              style: AppTextStyles.label.copyWith(color: AppColors.onLime),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryDetails extends StatelessWidget {
  const _SummaryDetails({required this.item});

  final TicketSelectionItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: _DetailTile(
            label: TicketSelectionStrings.scheduleLabel,
            icon: Icons.event_rounded,
            value: '${item.session} • ${item.time}',
          ),
        ),
        const Expanded(
          child: _DetailTile(
            label: TicketSelectionStrings.cageLabel,
            icon: Icons.shield_rounded,
            value: TicketSelectionStrings.cageValue,
          ),
        ),
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.label,
    required this.icon,
    required this.value,
  });

  final String label;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLavender,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(label, style: AppTextStyles.label),
          Row(
            spacing: 4,
            children: [
              Icon(icon, size: 15, color: AppColors.primary),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RulesNote extends StatelessWidget {
  const _RulesNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLavender,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.lavender,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.info_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    TicketSelectionStrings.rulesTitle,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    TicketSelectionStrings.rulesBody,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.tier, required this.seat});

  final TicketTier tier;
  final String seat;

  @override
  Widget build(BuildContext context) {
    return GlassPillBar(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
        child: Row(
          children: [
            Expanded(
              child: _TotalInfo(tier: tier, seat: seat),
            ),
            const SizedBox(width: 10),
            // Checkout akan disambungkan setelah kontrak pembayaran tersedia.
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Text(
                    TicketSelectionStrings.checkout,
                    style: AppTextStyles.title.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalInfo extends StatelessWidget {
  const _TotalInfo({required this.tier, required this.seat});

  final TicketTier tier;
  final String seat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${TicketSelectionStrings.totalLabel}${tier.shortName})',
          style: AppTextStyles.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                tier.price,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.primary,
                  fontSize: 18,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '• ${TicketSelectionStrings.seatPrefix}$seat',
              style: AppTextStyles.label,
            ),
          ],
        ),
      ],
    );
  }
}
