import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/auth/domain/rules/auth_rules.dart';

void main() {
  group('isEmail', () {
    test('menerima alamat email wajar', () {
      expect(AuthRules.isEmail('user@kicaugo.id'), isTrue);
      expect(AuthRules.isEmail('  user@kicaugo.id  '), isTrue);
    });

    test('menolak teks tanpa domain atau @', () {
      expect(AuthRules.isEmail('user@kicaugo'), isFalse);
      expect(AuthRules.isEmail('userkicaugo.id'), isFalse);
    });
  });

  group('isPhone', () {
    test('menerima awalan 08, 62, dan +62 termasuk spasi/strip', () {
      expect(AuthRules.isPhone('08123456789'), isTrue);
      expect(AuthRules.isPhone('628123456789'), isTrue);
      expect(AuthRules.isPhone('+62 812-3456-789'), isTrue);
    });

    test('menolak nomor terlalu pendek, terlalu panjang, atau bukan 8', () {
      expect(AuthRules.isPhone('0812345'), isFalse);
      expect(AuthRules.isPhone('0812345678901234'), isFalse);
      expect(AuthRules.isPhone('02112345678'), isFalse);
    });
  });

  test('identifier sah bila email atau nomor WhatsApp', () {
    expect(AuthRules.isValidIdentifier('user@kicaugo.id'), isTrue);
    expect(AuthRules.isValidIdentifier('08123456789'), isTrue);
    expect(AuthRules.isValidIdentifier('budi'), isFalse);
  });

  test('normalize menyamakan email dan format nomor WhatsApp', () {
    expect(AuthRules.normalize(' Test@Gmail.COM '), 'test@gmail.com');
    expect(AuthRules.normalize('+62 812-3456-7890'), '081234567890');
    expect(AuthRules.normalize('6281234567890'), '081234567890');
    expect(AuthRules.normalize('0812 3456 7890'), '081234567890');
  });
}
