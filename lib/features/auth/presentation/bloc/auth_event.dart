/// Event yang diterima [AuthBloc].
sealed class AuthEvent {
  const AuthEvent();
}

/// Pengguna mengirim formulir login.
final class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.identifier, required this.password});

  final String identifier;
  final String password;
}

/// Pengguna mengirim formulir daftar akun.
final class RegisterSubmitted extends AuthEvent {
  const RegisterSubmitted({
    required this.name,
    required this.identifier,
    required this.password,
  });

  final String name;
  final String identifier;
  final String password;
}

/// Pengguna meminta keluar dari sesi.
final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
