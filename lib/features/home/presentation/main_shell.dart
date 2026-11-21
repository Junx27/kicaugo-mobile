import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_nav_bar.dart';
import '../domain/usecases/get_home_content.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'home_strings.dart';

/// Kerangka tab utama: konten branch aktif dan navigasi pill mengambang.
///
/// [HomeBloc] dibuat di sini agar badge "Tiket Saya" ikut membaca data
/// Beranda dan state Beranda tetap hidup saat berpindah tab.
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
    required this.getHomeContent,
  });

  final StatefulNavigationShell navigationShell;
  final GetHomeContent getHomeContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(getHomeContent)..add(const HomeStarted()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: BlocSelector<HomeBloc, HomeState, int?>(
          selector: (state) => state.content?.summary.activeTicketCount,
          builder: (context, ticketCount) => PillNavBar(
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
              const PillNavItem(
                icon: Icons.person_rounded,
                label: HomeStrings.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
