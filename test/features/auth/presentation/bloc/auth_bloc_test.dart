import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/features/auth/domain/entities/user.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_state.dart';

import '../../../../support/fakes.dart';
import '../../../../support/pump_app.dart';

void main() {
  const user = User(name: demoName, identifier: demoIdentifier);
  const newUser = User(name: 'Sari', identifier: '08123456789');
  const loading = AuthState(status: AuthStatus.authenticating);

  AuthBloc buildBloc([FakeAuthRepository? repository]) =>
      createAuthBloc(repository: repository ?? FakeAuthRepository());

  // Sengaja non-const agar konstruktor event ikut tereksekusi (coverage).
  // ignore: prefer_const_constructors
  LoginSubmitted login() =>
      // ignore: prefer_const_constructors
      LoginSubmitted(identifier: demoIdentifier, password: demoPassword);

  // ignore: prefer_const_constructors
  LogoutRequested logout() => LogoutRequested();

  RegisterSubmitted register() => RegisterSubmitted(
    name: newUser.name,
    identifier: newUser.identifier,
    password: demoPassword,
  );

  group('login', () {
    blocTest<AuthBloc, AuthState>(
      'memancarkan authenticating lalu authenticated',
      build: buildBloc,
      act: (bloc) => bloc.add(login()),
      expect: () => const <AuthState>[
        loading,
        AuthState(status: AuthStatus.authenticated, user: user),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'memancarkan pesan saat kredensial ditolak',
      build: () => buildBloc(FakeAuthRepository(failuresRemaining: 1)),
      act: (bloc) => bloc.add(login()),
      expect: () => const <AuthState>[
        loading,
        AuthState(message: AppConstants.loginFailure),
      ],
    );
  });

  group('register', () {
    blocTest<AuthBloc, AuthState>(
      'daftar berhasil langsung membuat sesi',
      build: buildBloc,
      act: (bloc) => bloc.add(register()),
      expect: () => const <AuthState>[
        loading,
        AuthState(status: AuthStatus.authenticated, user: newUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'memancarkan pesan saat daftar gagal',
      build: () => buildBloc(FakeAuthRepository(failuresRemaining: 1)),
      act: (bloc) => bloc.add(register()),
      expect: () => const <AuthState>[
        loading,
        AuthState(message: AppConstants.registerFailure),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthBloc, AuthState>(
      'kembali ke state awal setelah berhasil keluar',
      build: buildBloc,
      seed: () => const AuthState(status: AuthStatus.authenticated, user: user),
      act: (bloc) => bloc.add(logout()),
      expect: () => const <AuthState>[AuthState()],
    );

    blocTest<AuthBloc, AuthState>(
      'memancarkan pesan saat logout gagal',
      build: () => buildBloc(FakeAuthRepository(logoutFailure: true)),
      seed: () => const AuthState(status: AuthStatus.authenticated, user: user),
      act: (bloc) => bloc.add(logout()),
      expect: () => const <AuthState>[AuthState(message: 'Gagal keluar')],
    );
  });
}
