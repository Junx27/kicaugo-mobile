import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';
import 'package:rumahkicau_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:rumahkicau_mobile/features/profile/domain/entities/profile_content.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/get_profile_content.dart';
import 'package:rumahkicau_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:rumahkicau_mobile/features/profile/presentation/profile_strings.dart';

import '../../../../support/fakes.dart';
import '../../../../support/layout.dart';
import '../../../../support/pump_app.dart';
import '../../profile_fakes.dart';

const Size _viewport = Size(420, 3600);
const String _signedInName = 'Sari';

/// Memasang halaman Profil dengan sesi dan sumber data yang bisa diatur.
Future<AuthBloc> _pumpProfile(
  WidgetTester tester, {
  GetProfileContent getProfileContent = instantProfile,
  AuthRepository? authRepository,
  bool signedIn = false,
}) async {
  tester.view.physicalSize = _viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final authBloc = createAuthBloc(repository: authRepository);
  addTearDown(authBloc.close);
  if (signedIn) {
    authBloc.add(
      const RegisterSubmitted(
        name: _signedInName,
        identifier: demoIdentifier,
        password: demoPassword,
      ),
    );
    await authBloc.stream.firstWhere((state) => state.isAuthenticated);
  }

  await tester.pumpWidget(
    BlocProvider.value(
      value: authBloc,
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: ProfilePage(getProfileContent: getProfileContent)),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 2));
  return authBloc;
}

void main() {
  testWidgets('latar mengikuti warna latar shell', (tester) async {
    await _pumpProfile(tester);

    expectShellBackground(tester, find.byType(ProfilePage));
  });

  testWidgets('menampilkan loading lalu konten profil', (tester) async {
    final completer = Completer<ProfileContent>();
    await _pumpProfile(
      tester,
      getProfileContent: GetProfileContent(
        CompleterProfileRepository(completer),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(sampleProfile);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2));

    expect(find.text(ProfileStrings.birdsTitle), findsOneWidget);
    expect(find.text('Halilintar'), findsOneWidget);
    expect(find.text(ProfileStrings.verified), findsOneWidget);
    expect(find.text('14'), findsOneWidget);
    expect(find.text('98%'), findsOneWidget);
    expect(find.text('Rp 1.450.000'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gagal memuat lalu coba lagi berhasil', (tester) async {
    await _pumpProfile(
      tester,
      getProfileContent: GetProfileContent(
        FakeProfileRepository(failuresRemaining: 1),
      ),
    );

    expect(find.text(profileFailure), findsOneWidget);

    await tester.tap(find.text(AppConstants.retryLabel));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2));

    expect(find.text(ProfileStrings.birdsTitle), findsOneWidget);
    expect(find.text(profileFailure), findsNothing);
  });

  testWidgets('memakai nama dari sesi yang aktif', (tester) async {
    await _pumpProfile(tester, signedIn: true);

    expect(find.text(_signedInName), findsOneWidget);
    expect(find.text(ProfileStrings.fallbackName), findsNothing);
  });

  testWidgets('memakai nama fallback tanpa sesi', (tester) async {
    await _pumpProfile(tester);

    expect(find.text(ProfileStrings.fallbackName), findsOneWidget);
  });

  testWidgets('menampilkan seluruh section profil', (tester) async {
    await _pumpProfile(tester);

    expect(find.text(ProfileStrings.birdsTitle), findsOneWidget);
    expect(find.text(ProfileStrings.birdsSubtitle(3)), findsOneWidget);
    expect(find.text('Halilintar'), findsOneWidget);
    expect(find.text('Black Phantom'), findsOneWidget);
    expect(find.text('Rawa Rontek'), findsOneWidget);
    expect(find.text(ProfileStrings.highlightLabel), findsOneWidget);
    expect(find.text(ProfileStrings.careTitle), findsOneWidget);
    expect(find.text(ProfileStrings.servicesTitle), findsOneWidget);
    expect(find.text(ProfileStrings.serviceMarketTitle), findsOneWidget);
    expect(find.text(ProfileStrings.soon), findsOneWidget);
    expect(find.text(ProfileStrings.settingsTitle), findsOneWidget);
    expect(find.text(AppConstants.appVersionLabel), findsOneWidget);
    expect(find.text(ProfileStrings.logout), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  final comingSoonTargets = <String, Finder Function()>{
    'QR': () => find.byKey(const Key('profile_qr')),
    'edit profil': () => find.byKey(const Key('profile_edit')),
    'bagikan kartu': () => find.byKey(const Key('profile_share')),
    'top up': () => find.byKey(const Key('profile_topup')),
    'tambah burung': () => find.byKey(const Key('profile_add_bird')),
    'sertifikat': () => find.text(ProfileStrings.certificateAction),
    'atur rawatan': () => find.text(ProfileStrings.careAction),
    'detail burung': () => find.text(ProfileStrings.detailAction),
    'layanan ring': () => find.byKey(const Key('profile_service_ring')),
    'layanan audio': () => find.byKey(const Key('profile_service_audio')),
  };
  comingSoonTargets.forEach((name, finder) {
    testWidgets('$name menampilkan segera hadir', (tester) async {
      await _pumpProfile(tester);

      await tester.ensureVisible(finder());
      await tester.tap(finder());
      await tester.pump();

      expect(find.text(AppConstants.comingSoon), findsOneWidget);
    });
  });

  testWidgets('tombol keluar memanggil logout dan menghapus sesi', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    final authBloc = await _pumpProfile(
      tester,
      authRepository: repository,
      signedIn: true,
    );

    await tester.ensureVisible(find.byKey(const Key('profile_logout')));
    await tester.tap(find.byKey(const Key('profile_logout')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2));

    expect(repository.logoutCalls, 1);
    expect(authBloc.state.isAuthenticated, isFalse);
  });
}
