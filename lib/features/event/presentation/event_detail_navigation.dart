import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../domain/entities/featured_contest.dart';
import 'pages/contest_detail_page.dart';

/// Membuka halaman detail event saat kartu di Beranda diketuk.
///
/// [GoRouter] dipakai bila tersedia agar transisi dan back stack konsisten.
/// Fallback [Navigator] menjaga kartu tetap bisa dipakai di widget test yang
/// berdiri sendiri tanpa router.
void pushEventDetail(BuildContext context, FeaturedContest contest) {
  final router = _routerOf(context);
  if (router != null) {
    router.push(AppRoutes.eventDetail, extra: contest);
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ContestDetailPage(contest: contest),
    ),
  );
}

GoRouter? _routerOf(BuildContext context) {
  try {
    return GoRouter.of(context);
  } catch (_) {
    return null;
  }
}
