import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/rules/auth_rules.dart';
import 'auth_remote_data_source.dart';

/// Akun yang tersimpan di sumber data palsu.
typedef FakeAccount = ({String name, String password});

/// Implementasi palsu sumber data autentikasi berbasis daftar akun di memori.
///
/// Login hanya berhasil untuk akun demo dan akun yang didaftarkan selama
/// aplikasi berjalan. Kredensial di bawah adalah DATA DEMO, bukan rahasia,
/// dan akan hilang saat sumber data diganti API sungguhan.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  FakeAuthRemoteDataSource({
    this.delay = const Duration(seconds: 1),
    Map<String, FakeAccount> accounts = demoAccounts,
  }) : _accounts = Map<String, FakeAccount>.of(accounts);

  /// Akun demo untuk mencoba aplikasi.
  static const String demoIdentifier = 'test@gmail.com';
  static const String demoName = 'Kicau Mania';
  static const String demoPassword = 'test123@';

  static const Map<String, FakeAccount> demoAccounts = <String, FakeAccount>{
    demoIdentifier: (name: demoName, password: demoPassword),
  };

  final Duration delay;
  final Map<String, FakeAccount> _accounts;

  @override
  Future<User> login({
    required String identifier,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    final account = _accounts[AuthRules.normalize(identifier)];
    if (account == null || account.password != password) {
      throw const AuthFailure(AppConstants.loginFailure);
    }
    return User(name: account.name, identifier: identifier.trim());
  }

  @override
  Future<User> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    final trimmedName = name.trim();
    if (!_isValidRegistration(trimmedName, identifier, password)) {
      throw const AuthFailure(AppConstants.registerFailure);
    }
    final key = AuthRules.normalize(identifier);
    if (_accounts.containsKey(key)) {
      throw const AuthFailure(AppConstants.accountExists);
    }
    _accounts[key] = (name: trimmedName, password: password);
    return User(name: trimmedName, identifier: identifier.trim());
  }

  @override
  Future<void> logout() => Future<void>.value();

  bool _isValidRegistration(String name, String identifier, String password) =>
      name.length >= AuthRules.minNameLength &&
      AuthRules.isValidIdentifier(identifier) &&
      password.length >= AuthRules.minPasswordLength;
}
