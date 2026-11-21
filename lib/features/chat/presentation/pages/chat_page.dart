import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../core/widgets/scroll_aware_fab.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_compose_button.dart';
import '../widgets/chat_empty_view.dart';
import '../widgets/chat_filter_chips.dart';
import '../widgets/chat_search_field.dart';
import '../widgets/chat_session_card.dart';

/// Tab Pesan: daftar sesi chat panitia dan komunitas.
///
/// [ChatCubit] disediakan oleh shell utama agar jumlah pesan belum dibaca
/// bisa dipakai bersama badge navigasi. Halaman hanya membaca state.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => const _ChatView();
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceLavender,
      child: SafeArea(
        top: false,
        bottom: false,
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) => switch (state.status) {
            ChatStatus.initial || ChatStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            ChatStatus.failure => LoadErrorView(
              message: state.message ?? AppConstants.homeLoadError,
              onRetry: () => context.read<ChatCubit>().load(),
            ),
            ChatStatus.success => _ChatContent(state: state),
          },
        ),
      ),
    );
  }
}

class _ChatContent extends StatelessWidget {
  const _ChatContent({required this.state});

  final ChatState state;

  static const double _gap = 16;
  static const double _fieldGap = 12;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatCubit>();
    final sessions = state.visibleSessions;
    final padding = MediaQuery.paddingOf(context);
    final topPadding = padding.top + _fieldGap;
    final bottomInset = padding.bottom + 48;

    return ScrollAwareFab(
      fab: const ChatComposeButton(),
      scrollable: ListView(
        padding: EdgeInsets.fromLTRB(_gap, topPadding, _gap, bottomInset),
        children: [
          ChatSearchField(onChanged: cubit.search),
          const SizedBox(height: _fieldGap),
          ChatFilterChips(
            selected: state.filter,
            onSelected: cubit.selectFilter,
          ),
          const SizedBox(height: _gap),
          if (sessions.isEmpty)
            const ChatEmptyView()
          else
            Column(
              spacing: _fieldGap,
              children: [
                for (final session in sessions)
                  ChatSessionCard(
                    session: session,
                    onTap: () => showComingSoon(context),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
