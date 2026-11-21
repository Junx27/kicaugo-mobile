import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/load_error_view.dart';
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

class _ChatContent extends StatefulWidget {
  const _ChatContent({required this.state});

  final ChatState state;

  @override
  State<_ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<_ChatContent> {
  static const double _gap = 16;
  static const double _fieldGap = 12;
  static const double _fabBottomGap = 12;
  static const Duration _fadeDuration = Duration(milliseconds: 200);

  /// Awalnya terlihat; scroll menuju atas menyembunyikan dan ke bawah
  /// menampilkan kembali tombol tulis pesan.
  bool _showCompose = true;

  bool _onScroll(ScrollUpdateNotification notification) {
    final delta = notification.scrollDelta;
    if (delta == null || delta == 0) return false;
    final shouldShow = delta > 0;
    if (shouldShow != _showCompose) {
      setState(() => _showCompose = shouldShow);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatCubit>();
    final sessions = widget.state.visibleSessions;
    final padding = MediaQuery.of(context).padding;
    final topPadding = padding.top + _fieldGap;

    // Dengan extendBody: true, padding.bottom sudah mencakup tinggi PillNavBar,
    // sehingga tinggi navbar tidak boleh dijumlahkan dua kali.
    final fabBottom = padding.bottom + _fabBottomGap;
    final bottomInset = padding.bottom + 48;

    return Stack(
      children: [
        NotificationListener<ScrollUpdateNotification>(
          onNotification: _onScroll,
          child: ListView(
            padding: EdgeInsets.fromLTRB(_gap, topPadding, _gap, bottomInset),
            children: [
              ChatSearchField(onChanged: cubit.search),
              const SizedBox(height: _fieldGap),
              ChatFilterChips(
                selected: widget.state.filter,
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
        ),
        Positioned(
          right: _gap,
          bottom: fabBottom,
          child: AnimatedOpacity(
            opacity: _showCompose ? 1 : 0,
            duration: _fadeDuration,
            child: IgnorePointer(
              ignoring: !_showCompose,
              child: const ChatComposeButton(),
            ),
          ),
        ),
      ],
    );
  }
}
