import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

/// Status autentikasi aplikasi.
enum AuthStatus { unauthenticated, authenticating, authenticated }

/// State yang dibaca router dan halaman login.
class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.message,
  });

  final AuthStatus status;
  final User? user;
  final String? message;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, user, message];
}
