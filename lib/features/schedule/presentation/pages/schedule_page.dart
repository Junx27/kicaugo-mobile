import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/entities/bird_category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/bird_category_style.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../data/datasources/fake_schedule_data_source.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import '../../domain/entities/schedule_region.dart';
import '../../domain/usecases/get_schedule_content.dart';
import '../cubit/schedule_cubit.dart';
import '../cubit/schedule_state.dart';
import '../schedule_format.dart';
import '../schedule_strings.dart';
import '../widgets/agenda_section.dart';
import '../widgets/calendar_strip.dart';
import '../widgets/featured_event_card.dart';
import '../widgets/schedule_chip_row.dart';
import '../widgets/schedule_header.dart';
import '../widgets/schedule_quick_actions.dart';

/// Tab Jadwal: kalender pekan, filter wilayah/hari/kelas, dan daftar agenda.
class SchedulePage extends StatelessWidget {
  const SchedulePage({
    super.key,
    this.getScheduleContent = const GetScheduleContent(
      ScheduleRepositoryImpl(FakeScheduleDataSource()),
    ),
  });

  final GetScheduleContent getScheduleContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleCubit(getScheduleContent)..load(),
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<ScheduleCubit, ScheduleState>(
          builder: (context, state) => switch (state.status) {
            ScheduleStatus.initial || ScheduleStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            ScheduleStatus.failure => LoadErrorView(
              message: state.message ?? AppConstants.homeLoadError,
              onRetry: context.read<ScheduleCubit>().load,
            ),
            ScheduleStatus.success => _ScheduleView(state: state),
          },
        ),
      ),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  const _ScheduleView({required this.state});

  final ScheduleState state;

  /// Ruang bawah agar konten terakhir tidak tertutup navigasi mengambang.
  static const double _bottomInset = 112;
  static const EdgeInsets _gutter = EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScheduleCubit>();
    final content = state.content!;
    final filter = state.filter;
    final agendas = state.visibleAgendas;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 16, bottom: _bottomInset),
            children: [
              Padding(
                padding: _gutter,
                child: ScheduleHeader(monthLabel: content.summary.monthLabel),
              ),
              const SizedBox(height: 12),
              ScheduleChipRow<ScheduleRegion>(
                items: ScheduleRegion.values,
                selected: filter.region,
                labelOf: (region) => _regionLabel(region, content.regions),
                iconOf: _regionIcon,
                onSelected: cubit.selectRegion,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: _gutter,
                child: CalendarStrip(
                  days: content.days,
                  selected: filter.day!,
                  onSelected: cubit.selectDay,
                  periodLabel: (
                    month: content.summary.monthLabel,
                    week: content.summary.weekLabel,
                  ),
                  eventCount: agendas.length,
                ),
              ),
              const SizedBox(height: 16),
              ScheduleChipRow<BirdCategory>(
                items: BirdCategory.values,
                selected: filter.category,
                labelOf: _categoryLabel,
                iconOf: _categoryIcon,
                onSelected: cubit.selectCategory,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: _gutter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 24,
                  children: [
                    FeaturedEventCard(event: content.featured),
                    AgendaSection(agendas: agendas),
                    ScheduleQuickActions(
                      mapDistance: content.summary.mapDistance,
                      alarmOn: state.alarmOn,
                      onAlarmChanged: cubit.setAlarm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _regionLabel(ScheduleRegion region, List<RegionCount> counts) {
    final match = counts.where((count) => count.region == region);
    return match.isEmpty
        ? region.label
        : '${region.label} (${match.first.arenas})';
  }

  static ChipIcon? _regionIcon(ScheduleRegion region) => switch (region) {
    ScheduleRegion.all => (
      icon: Icons.check_circle_rounded,
      color: AppColors.primary,
    ),
    ScheduleRegion.jabodetabek => (
      icon: Icons.near_me_rounded,
      color: AppColors.onLime,
    ),
    _ => null,
  };

  static String _categoryLabel(BirdCategory category) =>
      category == BirdCategory.all
      ? ScheduleStrings.allClasses
      : category.label;

  static ChipIcon _categoryIcon(BirdCategory category) => (
    icon: category == BirdCategory.all
        ? Icons.sports_score_rounded
        : category.icon,
    color: category.iconColor,
  );
}
