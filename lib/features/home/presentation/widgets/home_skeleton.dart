import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Placeholder Beranda saat konten masih dimuat.
///
/// Setiap bagian dibungkus shimmer sendiri dan memakai [Card] dengan ukuran
/// yang mengikuti widget konten aslinya agar tidak terjadi pergeseran layout.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  static const double _bottomInset = 112;
  static const EdgeInsets _gutter = EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: _bottomInset,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _GreetingSkeleton(),
          SizedBox(height: 12),
          _SearchSkeleton(),
          SizedBox(height: 12),
          _ChipSkeletonRow(),
          SizedBox(height: 16),
          _FeaturedSkeleton(),
          SizedBox(height: 16),
          _PairSkeleton(),
          SizedBox(height: 16),
          _TicketSkeleton(),
          SizedBox(height: 16),
          _ScheduleSkeleton(),
          SizedBox(height: 16),
          _CommunitySkeleton(),
        ],
      ),
    );
  }
}

class _GreetingSkeleton extends StatelessWidget {
  const _GreetingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Padding(
        padding: HomeSkeleton._gutter,
        child: Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _ShimmerCard(width: 36, height: 36, shape: CircleBorder()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: <Widget>[
                  _ShimmerCard(width: 96, height: 10),
                  _ShimmerCard(width: 160, height: 18),
                ],
              ),
            ),
            _ShimmerCard(width: 68, height: 32, shape: StadiumBorder()),
          ],
        ),
      ),
    );
  }
}

class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Padding(
        padding: HomeSkeleton._gutter,
        child: _ShimmerCard(height: 48, shape: StadiumBorder()),
      ),
    );
  }
}

class _ChipSkeletonRow extends StatelessWidget {
  const _ChipSkeletonRow();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SizedBox(
        height: 32,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: HomeSkeleton._gutter,
          child: Row(
            spacing: 8,
            children: <Widget>[
              _ShimmerCard(width: 96, height: 32, shape: StadiumBorder()),
              _ShimmerCard(width: 96, height: 32, shape: StadiumBorder()),
              _ShimmerCard(width: 96, height: 32, shape: StadiumBorder()),
              _ShimmerCard(width: 96, height: 32, shape: StadiumBorder()),
              _ShimmerCard(width: 96, height: 32, shape: StadiumBorder()),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedSkeleton extends StatelessWidget {
  const _FeaturedSkeleton();

  /// Durasi lebih lama agar sapuan shimmer mudah diamati saat pengujian.
  static const Duration _period = Duration(milliseconds: 3000);

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      period: _period,
      child: Padding(
        padding: HomeSkeleton._gutter,
        child: _ShimmerPanel(
          radius: AppTheme.showcaseRadius,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: <Widget>[
              Row(
                spacing: 8,
                children: <Widget>[
                  _ShimmerCard(width: 112, height: 24, shape: StadiumBorder()),
                  Spacer(),
                  _ShimmerCard(width: 72, height: 24, shape: StadiumBorder()),
                ],
              ),
              _ShimmerCard(width: 200, height: 18),
              _ShimmerCard(width: 160, height: 12),
              Row(
                spacing: 8,
                children: <Widget>[
                  Expanded(child: _ShimmerCard(height: 52)),
                  Expanded(child: _ShimmerCard(height: 52)),
                ],
              ),
              _ShimmerCard(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairSkeleton extends StatelessWidget {
  const _PairSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: HomeSkeleton._gutter,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: <Widget>[
            Expanded(child: _MiniCardSkeleton()),
            Expanded(child: _MiniCardSkeleton()),
          ],
        ),
      ),
    );
  }
}

class _MiniCardSkeleton extends StatelessWidget {
  const _MiniCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: _ShimmerPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            Row(
              children: <Widget>[
                _ShimmerCard(width: 32, height: 32, shape: CircleBorder()),
                Spacer(),
                _ShimmerCard(width: 56, height: 20, shape: StadiumBorder()),
              ],
            ),
            _ShimmerCard(width: 96, height: 10),
            _ShimmerCard(height: 18),
            _ShimmerCard(height: 12),
            Spacer(),
            _ShimmerCard(height: 28),
          ],
        ),
      ),
    );
  }
}

class _TicketSkeleton extends StatelessWidget {
  const _TicketSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Padding(
        padding: HomeSkeleton._gutter,
        child: _ShimmerPanel(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 12,
            children: <Widget>[
              Row(
                spacing: 8,
                children: <Widget>[
                  _ShimmerCard(width: 32, height: 32, shape: CircleBorder()),
                  Expanded(child: _ShimmerCard(height: 14)),
                  _ShimmerCard(width: 64, height: 22, shape: StadiumBorder()),
                ],
              ),
              _ShimmerPanel(
                radius: AppTheme.cardRadius,
                padding: EdgeInsets.all(14),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: <Widget>[
                          _ShimmerCard(height: 16),
                          _ShimmerCard(height: 12),
                          _ShimmerCard(width: 120, height: 16),
                        ],
                      ),
                    ),
                    _ShimmerCard(
                      width: 64,
                      height: 64,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppTheme.iconBoxRadius),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _ShimmerCard(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleSkeleton extends StatelessWidget {
  const _ScheduleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: HomeSkeleton._gutter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: <Widget>[
          _ScheduleHeaderSkeleton(),
          _ScheduleTileSkeleton(),
          _ScheduleTileSkeleton(),
          _ScheduleTileSkeleton(),
        ],
      ),
    );
  }
}

class _ScheduleHeaderSkeleton extends StatelessWidget {
  const _ScheduleHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: <Widget>[
                _ShimmerCard(width: 180, height: 18),
                _ShimmerCard(width: 220, height: 12),
              ],
            ),
          ),
          _ShimmerCard(width: 48, height: 14),
        ],
      ),
    );
  }
}

class _ScheduleTileSkeleton extends StatelessWidget {
  const _ScheduleTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: _ShimmerPanel(
        radius: AppTheme.panelRadius,
        padding: EdgeInsets.all(14),
        child: Row(
          spacing: 12,
          children: <Widget>[
            _ShimmerCard(
              width: 48,
              height: 48,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppTheme.cardRadius),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: <Widget>[
                  _ShimmerCard(width: 96, height: 16, shape: StadiumBorder()),
                  _ShimmerCard(height: 14),
                  _ShimmerCard(width: 140, height: 12),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 6,
              children: <Widget>[
                _ShimmerCard(width: 56, height: 18),
                _ShimmerCard(width: 56, height: 24, shape: StadiumBorder()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunitySkeleton extends StatelessWidget {
  const _CommunitySkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Padding(
        padding: HomeSkeleton._gutter,
        child: _ShimmerPanel(
          padding: EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: <Widget>[
              _ShimmerCard(width: 44, height: 44, shape: CircleBorder()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: <Widget>[
                    _ShimmerCard(height: 14),
                    _ShimmerCard(width: 160, height: 12),
                  ],
                ),
              ),
              _ShimmerCard(width: 16, height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Panel kartu berisi placeholder, mengikuti radius widget konten aslinya.
class _ShimmerPanel extends StatelessWidget {
  const _ShimmerPanel({
    required this.child,
    this.radius = AppTheme.panelRadius,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.border,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Blok solid berbentuk kartu yang nantinya diwarnai gradient shimmer.
class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({
    required this.height,
    this.width = double.infinity,
    this.shape,
  });

  final double height;
  final double width;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        margin: EdgeInsets.zero,
        color: AppColors.border,
        shape:
            shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppTheme.cardRadius),
              ),
            ),
      ),
    );
  }
}
