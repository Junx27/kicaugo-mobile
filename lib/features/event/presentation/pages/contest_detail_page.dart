import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_glass.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_pill_bar.dart';
import '../../../../core/widgets/hideable_bottom_bar.dart';
import '../../../../core/widgets/liquid_top_bar_icon_button.dart';
import '../../data/datasources/fake_contest_detail_data_source.dart';
import '../../data/repositories/contest_detail_repository_impl.dart';
import '../../domain/entities/contest_detail.dart';
import '../../domain/entities/featured_contest.dart';
import '../../domain/usecases/get_contest_detail.dart';
import '../bloc/contest_detail_cubit.dart';
import '../bloc/contest_detail_state.dart';
import '../contest_detail_strings.dart';

/// Halaman detail lomba.
class ContestDetailPage extends StatelessWidget {
  const ContestDetailPage({
    super.key,
    this.id,
    this.detail,
    this.contest,
    this.getContestDetail = const GetContestDetail(
      ContestDetailRepositoryImpl(FakeContestDetailDataSource()),
    ),
  });

  final int? id;
  final ContestDetail? detail;
  final FeaturedContest? contest;
  final GetContestDetail getContestDetail;

  ContestDetail? get _resolvedDetail {
    if (detail != null) return detail;
    if (contest != null) return _fromFeaturedContest(contest!);
    return null;
  }

  /// Sementara memakai isi dummy dari [FakeContestDetailDataSource] agar semua
  /// section tampil saat kontrak BE belum lengkap. Judul tetap mengikuti kartu
  /// yang diketuk pengguna.
  static ContestDetail _fromFeaturedContest(FeaturedContest contest) {
    const dummy = FakeContestDetailDataSource.content;
    return ContestDetail(
      id: dummy.id,
      header: ContestDetailHeader(
        title: contest.title.isEmpty ? dummy.header.title : contest.title,
        subtitle: dummy.header.subtitle,
        officialBadge: dummy.header.officialBadge,
        formatBadge: dummy.header.formatBadge,
        editionLabel: dummy.header.editionLabel,
        heroImageUrl: dummy.header.heroImageUrl,
        bannerImageUrl: dummy.header.bannerImageUrl,
        status: dummy.header.status,
      ),
      info: dummy.info,
      classes: dummy.classes,
      rules: dummy.rules,
    );
  }

  @override
  Widget build(BuildContext context) {
    final direct = _resolvedDetail;
    if (direct != null) {
      return _ContestDetailScaffold(detail: direct);
    }
    return BlocProvider(
      create: (_) =>
          ContestDetailCubit(getContestDetail, id: id ?? 101)..load(id),
      child: const _ContestDetailBody(),
    );
  }
}

class _ContestDetailBody extends StatelessWidget {
  const _ContestDetailBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContestDetailCubit, ContestDetailState>(
      builder: (context, state) {
        switch (state.status) {
          case ContestDetailStatus.initial:
          case ContestDetailStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case ContestDetailStatus.failure:
            return Scaffold(
              appBar: AppBar(title: const Text(ContestDetailStrings.title)),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message ?? ContestDetailStrings.notFound),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          context.read<ContestDetailCubit>().load(),
                      child: const Text(ContestDetailStrings.retry),
                    ),
                  ],
                ),
              ),
            );
          case ContestDetailStatus.success:
            return _ContestDetailScaffold(detail: state.detail!);
        }
      },
    );
  }
}

class _ContestDetailScaffold extends StatefulWidget {
  const _ContestDetailScaffold({required this.detail});

  final ContestDetail detail;

  @override
  State<_ContestDetailScaffold> createState() => _ContestDetailScaffoldState();
}

class _ContestDetailScaffoldState extends State<_ContestDetailScaffold> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
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
                  semanticLabel: 'Kembali',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            title: const SizedBox.shrink(),
            actions: [
              LiquidTopBarIconButton(
                icon: Icons.share_rounded,
                semanticLabel: 'Bagikan',
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              LiquidTopBarIconButton(
                icon: Icons.bookmark_border_rounded,
                semanticLabel: 'Simpan',
                onPressed: () {},
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 100 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroBanner(detail: detail),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      _HeroBadges(header: detail.header),
                      _KeyInfoCard(detail: detail),
                      _StatsRow(detail: detail),
                      _ClassesSection(detail: detail),
                      _RulesSection(detail: detail),
                      _MapSection(detail: detail),
                    ],
                  ),
                ),
              ],
            ),
          ),
          HideableBottomBar(
            controller: _scrollController,
            child: _BottomBar(detail: detail),
          ),
        ],
      ),
    );
  }
}

/// Banner utama selebar layar yang menyentuh tepi atas halaman.
class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.detail});

  static const double _height = 320;

  final ContestDetail detail;

  @override
  Widget build(BuildContext context) {
    final header = detail.header;
    return SizedBox(
      height: _height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _HeroBackground(imageUrl: header.heroImageUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x3315122B),
                  Color(0x4D15122B),
                  Color(0xE615122B),
                ],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (header.editionLabel.isNotEmpty) ...[
                  Text(
                    header.editionLabel.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.limeStrong,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  header.title,
                  style: AppTextStyles.headline.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.25,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 18,
                      color: AppColors.limeStrong,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        header.subtitle,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Latar banner: foto hero dari BE, atau aset dummy saat belum tersedia.
class _HeroBackground extends StatelessWidget {
  const _HeroBackground({required this.imageUrl});

  static const String _dummyAsset = 'assets/images/contest_hero.jpg';

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return Image.asset(
        _dummyAsset,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _HeroGradient(),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _HeroGradient(),
    );
  }
}

/// Cadangan bila foto hero tidak tersedia.
class _HeroGradient extends StatelessWidget {
  const _HeroGradient();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.periwinkleStrong, AppColors.periwinkle],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.military_tech_rounded,
          size: 120,
          color: AppColors.primaryRing,
        ),
      ),
    );
  }
}

/// Baris badge resmi & format di bawah banner.
class _HeroBadges extends StatelessWidget {
  const _HeroBadges({required this.header});

  final ContestDetailHeader header;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (header.officialBadge.isNotEmpty)
          _Badge(
            icon: Icons.verified_rounded,
            label: header.officialBadge,
            background: AppColors.lime,
            foreground: AppColors.onLime,
          ),
        if (header.formatBadge.isNotEmpty)
          _Badge(
            icon: Icons.grid_view_rounded,
            label: header.formatBadge,
            background: AppColors.lavender,
            foreground: AppColors.primary,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 14, color: foreground),
          Text(label, style: AppTextStyles.label.copyWith(color: foreground)),
        ],
      ),
    );
  }
}

class _KeyInfoCard extends StatelessWidget {
  const _KeyInfoCard({required this.detail});

  final ContestDetail detail;

  @override
  Widget build(BuildContext context) {
    final info = detail.info;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.periwinkle, AppColors.periwinkleStrong],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppColors.onLime,
                    ),
                    Text(
                      info.quota.label,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.onLime,
                      ),
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
                  color: AppColors.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      info.quota.remaining == null
                          ? 'Tersedia'
                          : 'Sisa ${info.quota.remaining} Slot',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _InfoRow(
            icon: Icons.calendar_month_rounded,
            label: ContestDetailStrings.scheduleHeading.toUpperCase(),
            title: info.schedule.date,
            subtitle:
                '${info.schedule.time} (Gate buka ${info.schedule.gateOpen})',
          ),
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: ContestDetailStrings.locationHeading.toUpperCase(),
            title: info.location.name,
            subtitle: info.location.address,
            trailing: TextButton(
              onPressed: () {},
              child: const Text(ContestDetailStrings.openMap),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.military_tech_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ContestDetailStrings.prizeHeading.toUpperCase(),
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        info.prize.total,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.emoji_events_rounded,
                            size: 14,
                            color: AppColors.yellowStrong,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              info.prize.trophy,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
              Text(
                title,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.detail});

  final ContestDetail detail;

  @override
  Widget build(BuildContext context) {
    final stats = detail.info.stats;
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.grain_rounded,
            label: 'Format',
            value: stats.format.label,
            note: stats.format.note,
          ),
        ),
        Expanded(
          child: _StatCard(
            icon: Icons.balance_rounded,
            label: 'Penjurian',
            value: stats.judging.label,
            note: stats.judging.note,
          ),
        ),
        Expanded(
          child: _StatCard(
            icon: Icons.stadium_rounded,
            label: 'Fasilitas',
            value: stats.facilities.label,
            note: stats.facilities.note,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.note,
  });

  final IconData icon;
  final String label;
  final String value;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.lavender,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            note,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassesSection extends StatelessWidget {
  const _ClassesSection({required this.detail});

  final ContestDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilihan Kelas & Sesi',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Pilih tiket sesi lomba yang ingin diikuti',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              ),
              child: Text(
                '${detail.classes.length} Kategori',
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        for (final item in detail.classes) _ClassCard(item: item),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.item});

  final ContestClass item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.ticketSelection, extra: item),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              const BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _Tag(
                              label: item.session,
                              color: AppColors.lavender,
                              foreground: AppColors.primary,
                            ),
                            _Tag(
                              label: item.slotLabel,
                              color: AppColors.lime,
                              foreground: AppColors.onLime,
                            ),
                          ],
                        ),
                        Text(
                          item.name,
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tiket',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        item.price,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLavender,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      size: 18,
                      color: AppColors.yellowStrong,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.prizeHighlight,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.color,
    required this.foreground,
  });

  final String label;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(color: foreground),
      ),
    );
  }
}

class _RulesSection extends StatelessWidget {
  const _RulesSection({required this.detail});

  final ContestDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.lavender,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pakem & Regulasi Arena',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Standar ketat penjurian PBI pusat',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          for (final rule in detail.rules)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLavender,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Icon(
                    rule.severity == 'error'
                        ? Icons.volume_off_rounded
                        : rule.severity == 'success'
                        ? Icons.groups_rounded
                        : Icons.inventory_2_rounded,
                    size: 20,
                    color: rule.severity == 'error'
                        ? AppColors.error
                        : rule.severity == 'success'
                        ? AppColors.limeStrong
                        : AppColors.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rule.title,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rule.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  const _MapSection({required this.detail});

  final ContestDetail detail;

  @override
  Widget build(BuildContext context) {
    final location = detail.info.location;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Peta Lokasi Arena',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  location.parking,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.periwinkle,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.map_rounded,
                    size: 48,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        const Icon(
                          Icons.directions_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        Text(
                          'Akses Tol TB Simatupang (5 Menit)',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.detail});

  final ContestDetail detail;

  @override
  Widget build(BuildContext context) {
    final ticket = detail.info.ticket;
    return GlassPillBar(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
        child: Row(
          children: [
            Expanded(child: _PriceInfo(ticket: ticket)),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: () => context.push(
                AppRoutes.ticketSelection,
                extra: detail.classes.first,
              ),
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
                  const Icon(
                    Icons.confirmation_number_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  Flexible(
                    child: Text(
                      ticket.cta,
                      style: AppTextStyles.title.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

/// Ringkasan harga di sisi kiri pill bawah.
class _PriceInfo extends StatelessWidget {
  const _PriceInfo({required this.ticket});

  final ContestTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 1,
      children: [
        Text(
          '${ContestDetailStrings.ticketLabel} ${ticket.unit}',
          style: AppTextStyles.caption.copyWith(
            fontSize: 9,
            letterSpacing: 0.3,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          ticket.startingPrice,
          style: AppTextStyles.title.copyWith(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
