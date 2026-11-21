import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/glow_orb.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../core/widgets/top_bars.dart';
import '../../data/datasources/fake_help_center_data_source.dart';
import '../../data/repositories/help_center_repository_impl.dart';
import '../../domain/entities/help_center_content.dart';
import '../../domain/usecases/get_help_center_content.dart';
import '../cubit/help_center_cubit.dart';
import '../cubit/help_center_state.dart';
import '../help_center_strings.dart';
import '../widgets/help_contact_card.dart';
import '../widgets/help_faq_section.dart';
import '../widgets/help_quick_actions.dart';
import '../widgets/help_search_field.dart';

/// Halaman Pusat Bantuan & Tim Panitia.
///
/// [getHelpCenterContent] memakai data demo secara default dan dapat diganti
/// saat test atau ketika sumber data API tersedia.
class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({
    super.key,
    this.getHelpCenterContent = const GetHelpCenterContent(
      HelpCenterRepositoryImpl(FakeHelpCenterDataSource()),
    ),
  });

  final GetHelpCenterContent getHelpCenterContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HelpCenterCubit(getHelpCenterContent)..load(),
      child: const _HelpCenterView(),
    );
  }
}

class _HelpCenterView extends StatelessWidget {
  const _HelpCenterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLavender,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HelpTopBar(),
            Expanded(
              child: BlocBuilder<HelpCenterCubit, HelpCenterState>(
                builder: (context, state) => switch (state.status) {
                  HelpCenterStatus.initial || HelpCenterStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  HelpCenterStatus.failure => LoadErrorView(
                    message: state.message ?? AppConstants.homeLoadError,
                    onRetry: () => context.read<HelpCenterCubit>().load(),
                  ),
                  HelpCenterStatus.success => _HelpContent(state: state),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpTopBar extends StatelessWidget {
  const _HelpTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
      child: Row(
        spacing: 4,
        children: [
          IconButton(
            key: const Key('help_back'),
            tooltip: HelpCenterStrings.backTooltip,
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
              HelpCenterStrings.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.title,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTones.lime.light,
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 13,
                  color: AppTones.lime.foreground,
                ),
                Text(
                  HelpCenterStrings.secure,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppTones.lime.foreground,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const ProfileAvatarButton(),
        ],
      ),
    );
  }
}

class _HelpContent extends StatelessWidget {
  const _HelpContent({required this.state});

  final HelpCenterState state;

  @override
  Widget build(BuildContext context) {
    final content = state.content!;
    final cubit = context.read<HelpCenterCubit>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _IntroBanner(),
          const SizedBox(height: 16),
          HelpSearchField(initialQuery: state.query, onChanged: cubit.search),
          const SizedBox(height: 24),
          HelpQuickActions(actions: content.quickActions),
          const SizedBox(height: 24),
          _EventHeroCard(event: content.event, contacts: content.contacts),
          const SizedBox(height: 24),
          HelpFaqSection(
            faqs: state.visibleFaqs,
            expandedFaqId: state.expandedFaqId,
            onToggle: cubit.toggleFaq,
          ),
          const SizedBox(height: 24),
          const _SupportCtaCard(),
        ],
      ),
    );
  }
}

class _IntroBanner extends StatelessWidget {
  const _IntroBanner();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Row(
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
              HelpCenterStrings.serviceEyebrow,
              style: AppTextStyles.eyebrow.copyWith(
                color: AppColors.primary,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        Text(HelpCenterStrings.heading, style: AppTextStyles.headline),
        Text(HelpCenterStrings.subtitle, style: AppTextStyles.caption),
      ],
    );
  }
}

class _EventHeroCard extends StatelessWidget {
  const _EventHeroCard({required this.event, required this.contacts});

  final HelpEventInfo event;
  final List<HelpContact> contacts;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -36,
            bottom: -36,
            child: GlowOrb(size: 144, color: AppColors.lavender, alpha: 0.7),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Row(
                            spacing: 6,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified_rounded,
                                  size: 12,
                                  color: AppColors.surface,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  event.registrationLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.eyebrow.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            event.title,
                            style: AppTextStyles.title.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              Expanded(
                                child: Text(
                                  event.venue,
                                  style: AppTextStyles.caption,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const _FieldReadyBadge(),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLavender,
                    borderRadius: BorderRadius.circular(AppTheme.iconBoxRadius),
                  ),
                  child: Row(
                    spacing: 6,
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      Expanded(
                        child: Text(
                          HelpCenterStrings.fieldHours(event.fieldHours),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (final contact in contacts)
                  HelpContactCard(contact: contact),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldReadyBadge extends StatelessWidget {
  const _FieldReadyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTones.lime.light,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppTones.lime.strong,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            HelpCenterStrings.fieldReady,
            style: AppTextStyles.eyebrow.copyWith(
              color: AppTones.lime.foreground,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCtaCard extends StatelessWidget {
  const _SupportCtaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.panelRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Icon(
                  Icons.headset_mic_rounded,
                  size: 24,
                  color: AppColors.surface,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      HelpCenterStrings.supportTitle,
                      style: AppTextStyles.title,
                    ),
                    Text(
                      HelpCenterStrings.supportBody,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          FilledButton.icon(
            key: const Key('help_create_ticket'),
            onPressed: () => showComingSoon(context),
            icon: const Icon(Icons.confirmation_number_rounded, size: 20),
            label: const Text(HelpCenterStrings.createTicket),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: const [
              _TrustItem(label: HelpCenterStrings.archived),
              _Dot(),
              _TrustItem(label: HelpCenterStrings.escalation),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 14,
          color: AppColors.primary,
        ),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: AppColors.border,
        shape: BoxShape.circle,
      ),
    );
  }
}
