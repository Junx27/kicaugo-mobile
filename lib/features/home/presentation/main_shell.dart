import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_nav_bar.dart';
import '../../chat/data/datasources/fake_chat_data_source.dart';
import '../../chat/data/repositories/chat_repository_impl.dart';
import '../../chat/domain/usecases/get_chat_sessions.dart';
import '../../chat/presentation/cubit/chat_cubit.dart';
import '../../chat/presentation/cubit/chat_state.dart';
import '../domain/usecases/get_home_content.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'home_strings.dart';

/// Kerangka tab utama: konten branch aktif dan navigasi pill mengambang.
///
/// [HomeBloc] dan [ChatCubit] dibuat di sini agar badge "Tiket Saya" dan
/// "Chat" dibaca dari state yang sama dan tetap hidup saat berpindah tab.
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
    required this.getHomeContent,
    this.getChatSessions = const GetChatSessions(
      ChatRepositoryImpl(FakeChatDataSource()),
    ),
  });

  final StatefulNavigationShell navigationShell;
  final GetHomeContent getHomeContent;
  final GetChatSessions getChatSessions;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              HomeBloc(getHomeContent)..add(const HomeStarted()),
        ),
        BlocProvider(create: (context) => ChatCubit(getChatSessions)..load()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: BlocSelector<HomeBloc, HomeState, int?>(
          selector: (state) => state.content?.summary.activeTicketCount,
          builder: (context, ticketCount) =>
              BlocSelector<ChatCubit, ChatState, int>(
                selector: (state) => state.unreadCount,
                builder: (context, unreadCount) => PillNavBar(
                  currentIndex: navigationShell.currentIndex,
                  onSelected: (index) => navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  ),
                  items: [
                    const PillNavItem(
                      icon: Icons.home_rounded,
                      label: HomeStrings.navHome,
                    ),
                    const PillNavItem(
                      icon: Icons.calendar_month_rounded,
                      label: HomeStrings.navSchedule,
                    ),
                    PillNavItem(
                      icon: Icons.confirmation_number_rounded,
                      label: HomeStrings.navTickets,
                      badge: ticketCount,
                    ),
                    const PillNavItem(
                      icon: Icons.groups_rounded,
                      label: HomeStrings.navCommunity,
                    ),
                    PillNavItem(
                      icon: Icons.chat_rounded,
                      label: HomeStrings.navChat,
                      badge: unreadCount,
                    ),
                    const PillNavItem(
                      icon: Icons.person_rounded,
                      label: HomeStrings.navProfile,
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
