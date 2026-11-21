import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Mengelola status sesi: masuk, daftar (langsung masuk), dan keluar.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase login,
    required RegisterUseCase register,
    required LogoutUseCase logout,
  }) : _login = login,
       _register = register,
       _logout = logout,
       super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final LoginUseCase _login;
  final RegisterUseCase _register;
  final LogoutUseCase _logout;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) {
    return _authenticate(
      emit,
      () => _login(identifier: event.identifier, password: event.password),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) {
    return _authenticate(
      emit,
      () => _register(
        name: event.name,
        identifier: event.identifier,
        password: event.password,
      ),
    );
  }

  /// Alur bersama login dan daftar: loading, lalu sesi aktif atau pesan gagal.
  Future<void> _authenticate(
    Emitter<AuthState> emit,
    Future<User> Function() request,
  ) async {
    emit(const AuthState(status: AuthStatus.authenticating));
    try {
      final user = await request();
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } on Failure catch (failure) {
      emit(AuthState(message: failure.message));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _logout();
      emit(const AuthState());
    } on Failure catch (failure) {
      emit(AuthState(message: failure.message));
    }
  }
}
