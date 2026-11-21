import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/domain/usecases/get_home_content.dart';

/// Root widget KicauKu.
class KicauKuApp extends StatefulWidget {
  const KicauKuApp({
    super.key,
    required this.authBloc,
    required this.getHomeContent,
  });

  final AuthBloc authBloc;
  final GetHomeContent getHomeContent;

  @override
  State<KicauKuApp> createState() => _KicauKuAppState();
}

class _KicauKuAppState extends State<KicauKuApp> {
  late final AuthRouterNotifier _refreshNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _refreshNotifier = AuthRouterNotifier(widget.authBloc.stream);
    _router = createRouter(
      authBloc: widget.authBloc,
      getHomeContent: widget.getHomeContent,
      refreshListenable: _refreshNotifier,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    _refreshNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authBloc,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
