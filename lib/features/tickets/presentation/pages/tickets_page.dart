import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../data/datasources/fake_tickets_data_source.dart';
import '../../data/repositories/tickets_repository_impl.dart';
import '../../domain/usecases/get_tickets_content.dart';
import '../cubit/tickets_cubit.dart';
import '../cubit/tickets_state.dart';
import '../widgets/tickets_filters.dart';
import '../widgets/tickets_tab_content.dart';

/// Tab "Tiket Saya": tiket aktif, riwayat selesai, dan tiket dibatalkan.
///
/// [getTickets] memakai data demo secara default dan dapat diganti saat test
/// atau ketika sumber data API tersedia.
class TicketsPage extends StatelessWidget {
  const TicketsPage({
    super.key,
    this.getTickets = const GetTicketsContent(
      TicketsRepositoryImpl(FakeTicketsDataSource()),
    ),
  });

  final GetTicketsContent getTickets;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketsCubit(getTickets)..load(),
      child: const _TicketsView(),
    );
  }
}

class _TicketsView extends StatelessWidget {
  const _TicketsView();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceLavender,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<TicketsCubit, TicketsState>(
                builder: (context, state) => switch (state.status) {
                  TicketsStatus.initial || TicketsStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  TicketsStatus.failure => LoadErrorView(
                    message: state.message ?? AppConstants.homeLoadError,
                    onRetry: context.read<TicketsCubit>().load,
                  ),
                  TicketsStatus.success => _TicketsList(state: state),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketsList extends StatelessWidget {
  const _TicketsList({required this.state});

  final TicketsState state;

  /// Ruang bawah agar konten terakhir tidak tertutup navigasi mengambang.
  static const double _bottomInset = 112;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TicketsCubit>();
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: _bottomInset),
      children: [
        TicketsTabs(
          current: state.tab,
          countFor: state.countFor,
          onSelected: cubit.selectTab,
        ),
        const SizedBox(height: 8),
        BirdFilterRow(
          selected: state.category,
          onSelected: cubit.selectCategory,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TicketsTabContent(
            state: state,
            onShowHistory: () => cubit.selectTab(TicketsTab.history),
          ),
        ),
      ],
    );
  }
}
