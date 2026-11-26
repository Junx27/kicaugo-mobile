import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/event/domain/entities/contest_detail.dart';
import '../../features/event/domain/entities/featured_contest.dart';
import '../../features/event/domain/usecases/get_contest_detail.dart';
import '../../features/event/presentation/pages/contest_detail_page.dart';
import '../../features/help_center/presentation/pages/help_center_page.dart';
import '../../features/home/domain/usecases/get_home_content.dart';
import '../../features/home/presentation/main_shell.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/venue_map_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/domain/usecases/update_current_location.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/reminders/presentation/pages/reminders_page.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/tickets/domain/entities/ticket_selection_item.dart';
import '../../features/tickets/presentation/pages/ticket_history_page.dart';
import '../../features/tickets/presentation/pages/ticket_selection_page.dart';
import '../../features/tickets/presentation/pages/tickets_page.dart';
import '../location/location_service.dart';
import '../routing/route_service.dart';
import 'app_navigator_observer.dart';
import 'app_routes.dart';
import 'venue_map_args.dart';

/// Jembatan stream [AuthBloc] ke [Listenable] milik `GoRouter`.
class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Membuat router dengan dependency yang sudah dirakit di composition root.
///
/// Rute publik ([AppRoutes.publicRoutes]) bisa dibuka tanpa sesi; rute lain
/// dialihkan ke login. Pengguna yang sudah masuk diarahkan ke beranda bila
/// membuka rute publik. Setelah masuk, lima tab berada di [MainShell].
GoRouter createRouter({
  required AuthBloc authBloc,
  required GetHomeContent getHomeContent,
  required GetContestDetail getContestDetail,
  required LocationService locationService,
  required RouteService routeService,
  required UpdateCurrentLocation updateCurrentLocation,
  required Listenable refreshListenable,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    observers: <NavigatorObserver>[AppNavigatorObserver()],
    redirect: (context, state) =>
        authRedirect(authBloc.state.isAuthenticated, state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.helpCenter,
        builder: (context, state) => const HelpCenterPage(),
      ),
      GoRoute(
        path: AppRoutes.reminders,
        builder: (context, state) => const RemindersPage(),
      ),
      GoRoute(
        path: AppRoutes.ticketHistory,
        builder: (context, state) => const TicketHistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.venueMap,
        builder: (context, state) {
          final extra = state.extra;
          return VenueMapPage(
            args: extra is VenueMapArgs ? extra : null,
            routeService: routeService,
            locationService: locationService,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.eventDetail,
        builder: (context, state) =>
            _buildEventDetailPage(state.extra, getContestDetail),
      ),
      GoRoute(
        path: AppRoutes.ticketSelection,
        builder: (context, state) =>
            TicketSelectionPage(item: _toTicketSelectionItem(state.extra)),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(
          navigationShell: navigationShell,
          getHomeContent: getHomeContent,
          locationService: locationService,
          updateCurrentLocation: updateCurrentLocation,
        ),
        branches: [
          _branch(AppRoutes.home, (context, state) => const HomePage()),
          _branch(AppRoutes.schedule, (context, state) => const SchedulePage()),
          _branch(AppRoutes.tickets, (context, state) => const TicketsPage()),
          _branch(
            AppRoutes.community,
            (context, state) => const CommunityPage(),
          ),
          _branch(AppRoutes.chat, (context, state) => const ChatPage()),
          _branch(AppRoutes.profile, (context, state) => const ProfilePage()),
        ],
      ),
    ],
  );
}

StatefulShellBranch _branch(String path, GoRouterWidgetBuilder builder) {
  return StatefulShellBranch(
    routes: [GoRoute(path: path, builder: builder)],
  );
}

ContestDetailPage _buildEventDetailPage(
  Object? extra,
  GetContestDetail getContestDetail,
) {
  if (extra is FeaturedContest) {
    return ContestDetailPage(
      contest: extra,
      getContestDetail: getContestDetail,
    );
  }
  final id = extra is int ? extra : null;
  return ContestDetailPage(id: id, getContestDetail: getContestDetail);
}

/// Menyesuaikan kelas lomba dari detail event ke entitas domain tiket.
TicketSelectionItem? _toTicketSelectionItem(Object? extra) {
  if (extra is TicketSelectionItem) return extra;
  if (extra is ContestClass) {
    return TicketSelectionItem(
      id: extra.id,
      name: extra.name,
      session: extra.session,
      time: extra.time,
      price: extra.price,
    );
  }
  return null;
}

/// Menentukan tujuan alih rute berdasarkan status sesi; `null` bila tetap.
String? authRedirect(bool isAuthenticated, String location) {
  final isPublic = AppRoutes.publicRoutes.contains(location);
  if (!isAuthenticated && !isPublic) {
    return AppRoutes.login;
  }
  if (isAuthenticated && isPublic) {
    return AppRoutes.home;
  }
  return null;
}
