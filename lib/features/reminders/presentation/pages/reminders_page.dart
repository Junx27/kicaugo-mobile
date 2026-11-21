import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../data/datasources/fake_reminders_data_source.dart';
import '../../data/repositories/reminders_repository_impl.dart';
import '../../domain/usecases/get_reminders_content.dart';
import '../cubit/reminders_cubit.dart';
import '../cubit/reminders_state.dart';
import '../reminders_strings.dart';
import '../widgets/care_schedule_section.dart';
import '../widgets/contest_alarm_card.dart';
import '../widgets/reminder_alert_settings.dart';
import '../widgets/reminder_bird_filter.dart';

/// Halaman pengingat rawatan dan alarm lomba.
///
/// Pola B: sumber data diinjeksi lewat default parameter agar mudah diganti
/// saat test atau ketika sumber data API tersedia.
class RemindersPage extends StatelessWidget {
  const RemindersPage({
    super.key,
    this.getRemindersContent = const GetRemindersContent(
      RemindersRepositoryImpl(FakeRemindersDataSource()),
    ),
  });

  final GetRemindersContent getRemindersContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemindersCubit(getRemindersContent)..load(),
      child: const _RemindersView(),
    );
  }
}

class _RemindersView extends StatelessWidget {
  const _RemindersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLavender,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _RemindersTopBar(),
            Expanded(
              child: BlocBuilder<RemindersCubit, RemindersState>(
                builder: (context, state) => switch (state.status) {
                  RemindersStatus.initial || RemindersStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  RemindersStatus.failure => LoadErrorView(
                    message: state.message ?? AppConstants.homeLoadError,
                    onRetry: () => context.read<RemindersCubit>().load(),
                  ),
                  RemindersStatus.success => _RemindersContent(state: state),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemindersTopBar extends StatelessWidget {
  const _RemindersTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        spacing: 4,
        children: [
          IconButton(
            key: const Key('reminders_back'),
            tooltip: RemindersStrings.backTooltip,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.profile);
              }
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: Text(
              RemindersStrings.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.title,
            ),
          ),
          IconButton(
            key: const Key('reminders_add'),
            tooltip: RemindersStrings.addTooltip,
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            key: const Key('reminders_settings'),
            tooltip: RemindersStrings.settingsTooltip,
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
    );
  }
}

class _RemindersContent extends StatelessWidget {
  const _RemindersContent({required this.state});

  final RemindersState state;

  /// Ruang bawah agar CTA tidak tertutup navigasi mengambang.
  static const double _bottomInset = 112;

  @override
  Widget build(BuildContext context) {
    final content = state.content!;
    final cubit = context.read<RemindersCubit>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, _bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Text(
                RemindersStrings.intro,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              ReminderBirdFilter(
                birds: content.birds,
                selectedBirdId: state.selectedBirdId,
                onSelected: cubit.selectBird,
              ),
            ],
          ),
          ContestAlarmCard(
            contest: content.contest,
            onToggleReminder: cubit.toggleContestReminder,
            onAddAlarm: () => showComingSoon(context),
          ),
          CareScheduleSection(
            reminders: state.visibleCareReminders,
            doneCount: state.doneCount,
            onToggleDone: cubit.toggleCareDone,
            onToggleAlarm: cubit.toggleCareAlarm,
          ),
          ReminderAlertSettings(
            ringtone: content.settings.ringtone,
            vibrationOn: content.settings.vibrationOn,
            onPlayRingtone: () => showComingSoon(context),
            onVibrationChanged: (_) => cubit.toggleVibration(),
          ),
          FilledButton.icon(
            key: const Key('reminders_create'),
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text(RemindersStrings.createCare),
          ),
        ],
      ),
    );
  }
}
