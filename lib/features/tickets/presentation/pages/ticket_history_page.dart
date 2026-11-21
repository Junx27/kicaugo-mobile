import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../data/datasources/fake_ticket_history_data_source.dart';
import '../../data/repositories/ticket_history_repository_impl.dart';
import '../../domain/usecases/get_ticket_history_content.dart';
import '../cubit/ticket_history_cubit.dart';
import '../cubit/ticket_history_state.dart';
import '../widgets/ticket_history_active_card.dart';
import '../widgets/ticket_history_completed_card.dart';
import '../widgets/ticket_history_info_note.dart';
import '../widgets/ticket_history_pending_card.dart';
import '../widgets/ticket_history_qr_modal.dart';
import '../widgets/ticket_history_refund_card.dart';
import '../widgets/ticket_history_sub_header.dart';
import '../widgets/ticket_history_summary_bento.dart';
import '../widgets/ticket_history_timeline_group.dart';
import '../widgets/ticket_history_top_bar.dart';
import '../widgets/ticket_history_winner_card.dart';

/// Halaman riwayat tiket gantangan & invoice.
class TicketHistoryPage extends StatelessWidget {
  const TicketHistoryPage({
    super.key,
    this.getTicketHistory = const GetTicketHistoryContent(
      TicketHistoryRepositoryImpl(FakeTicketHistoryDataSource()),
    ),
  });

  final GetTicketHistoryContent getTicketHistory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketHistoryCubit(getTicketHistory)..load(),
      child: const _TicketHistoryView(),
    );
  }
}

class _TicketHistoryView extends StatefulWidget {
  const _TicketHistoryView();

  @override
  State<_TicketHistoryView> createState() => _TicketHistoryViewState();
}

class _TicketHistoryViewState extends State<_TicketHistoryView> {
  String _filter = 'all';

  void _setFilter(String value) => setState(() => _filter = value);

  void _download(String fileName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Mengunduh: $fileName...')));
  }

  void _showQr() {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.6),
      builder: (context) => const TicketHistoryQrModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TicketHistoryTopBar(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: BlocBuilder<TicketHistoryCubit, TicketHistoryState>(
                builder: (context, state) => switch (state.status) {
                  TicketHistoryStatus.initial || TicketHistoryStatus.loading =>
                    const Center(child: CircularProgressIndicator()),
                  TicketHistoryStatus.failure => LoadErrorView(
                    message: state.message ?? AppConstants.homeLoadError,
                    onRetry: () => context.read<TicketHistoryCubit>().load(),
                  ),
                  TicketHistoryStatus.success => SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        TicketHistorySubHeader(
                          filter: _filter,
                          onFilter: _setFilter,
                        ),
                        const SizedBox(height: AppTheme.sectionSpacing),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TicketHistorySummaryBento(),
                        ),
                        const SizedBox(height: AppTheme.sectionSpacing),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TicketHistoryTimelineGroup(
                            icon: Icons.calendar_month,
                            title: 'Mei 2025 (Mendatang & Aktif)',
                            badge: '2 Pesanan',
                            visible: _filter == 'all' || _filter == 'ready',
                            children: [
                              TicketHistoryActiveCard(
                                onShowQr: _showQr,
                                onDownload: _download,
                              ),
                              TicketHistoryPendingCard(
                                onShowQr: _showQr,
                                onDownload: _download,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.sectionSpacing),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TicketHistoryTimelineGroup(
                            icon: Icons.history_toggle_off,
                            title: 'April 2025 (Riwayat Selesai)',
                            badge: '5 Selesai',
                            visible: _filter == 'all' || _filter == 'completed',
                            children: [
                              TicketHistoryWinnerCard(onDownload: _download),
                              TicketHistoryCompletedCard(onDownload: _download),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.sectionSpacing),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TicketHistoryTimelineGroup(
                            icon: Icons.replay,
                            title: 'Maret 2025 (Pengembalian Dana)',
                            badge: '1 Dibatalkan',
                            visible: _filter == 'all' || _filter == 'refund',
                            children: [
                              TicketHistoryRefundCard(onDownload: _download),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.sectionSpacing),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TicketHistoryInfoNote(onDownload: _download),
                        ),
                        const SizedBox(height: AppTheme.sectionSpacing),
                      ],
                    ),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
