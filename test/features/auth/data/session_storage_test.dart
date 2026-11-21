import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/shared_preferences_session_storage.dart';
import 'package:rumahkicau_mobile/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const user = User(name: 'Kicau Mania', identifier: 'test@gmail.com');

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('readSession null bila belum ada data', () async {
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);

    expect(await storage.readSession(), isNull);
  });

  test('saveSession lalu readSession mengembalikan user', () async {
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);

    await storage.saveSession(user);

    expect(await storage.readSession(), user);
  });

  test('clearSession menghapus sesi', () async {
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);

    await storage.saveSession(user);
    await storage.clearSession();

    expect(await storage.readSession(), isNull);
  });

  test('readSession null bila hanya sebagian data tersimpan', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session_user_name': 'Kicau Mania',
    });
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);

    expect(await storage.readSession(), isNull);
  });

  test('token ikut tersimpan dan bisa dibaca terpisah', () async {
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);
    const authenticated = User(
      name: 'Kicau Mania',
      identifier: 'test@gmail.com',
      token: 'jwt-token',
    );

    await storage.saveSession(authenticated);

    expect(await storage.readSession(), authenticated);
    expect(await storage.readToken(), 'jwt-token');
  });

  test('token lama dihapus bila sesi baru tanpa token', () async {
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);

    await storage.saveSession(
      const User(
        name: 'Kicau Mania',
        identifier: 'test@gmail.com',
        token: 'jwt',
      ),
    );
    await storage.saveSession(user);

    expect(await storage.readToken(), isNull);
    expect(await storage.readSession(), user);
  });

  test('clearSession juga menghapus token', () async {
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);

    await storage.saveSession(
      const User(
        name: 'Kicau Mania',
        identifier: 'test@gmail.com',
        token: 'jwt',
      ),
    );
    await storage.clearSession();

    expect(await storage.readToken(), isNull);
    expect(await storage.readSession(), isNull);
  });

  test('readToken null untuk token kosong', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session_token': '',
    });
    final prefs = await SharedPreferences.getInstance();
    final storage = SharedPreferencesSessionStorage(prefs);

    expect(await storage.readToken(), isNull);
  });
}
