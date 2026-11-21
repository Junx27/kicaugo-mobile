import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import 'session_storage.dart';

/// Implementasi [SessionStorage] berbasis shared_preferences.
class SharedPreferencesSessionStorage implements SessionStorage {
  const SharedPreferencesSessionStorage(this._prefs);

  final SharedPreferences _prefs;

  static const String _nameKey = 'session_user_name';
  static const String _identifierKey = 'session_user_identifier';

  @override
  Future<User?> readSession() async {
    final name = _prefs.getString(_nameKey);
    final identifier = _prefs.getString(_identifierKey);
    if (name == null || name.isEmpty) return null;
    if (identifier == null || identifier.isEmpty) return null;
    return User(name: name, identifier: identifier);
  }

  @override
  Future<void> saveSession(User user) async {
    await _prefs.setString(_nameKey, user.name);
    await _prefs.setString(_identifierKey, user.identifier);
  }

  @override
  Future<void> clearSession() async {
    await _prefs.remove(_nameKey);
    await _prefs.remove(_identifierKey);
  }
}
