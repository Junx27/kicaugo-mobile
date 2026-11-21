import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/entities/bird_category.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/network/json_mapper.dart';

void expectInvalid(void Function() action) {
  expect(
    action,
    throwsA(
      isA<DataFailure>().having(
        (failure) => failure.message,
        'message',
        AppConstants.apiInvalidResponse,
      ),
    ),
  );
}

void main() {
  group('JsonMapper.object', () {
    test('menerima map bertipe dan map untyped', () {
      final typed = <String, dynamic>{'a': 1};
      expect(JsonMapper.object(typed), same(typed));

      final untyped = <dynamic, dynamic>{'a': 1};
      expect(JsonMapper.object(untyped), equals(typed));
    });

    test(
      'menolak nilai bukan map',
      () => expectInvalid(() {
        JsonMapper.object('bukan map');
      }),
    );
  });

  group('JsonMapper.string', () {
    test('mengambil teks yang tidak kosong', () {
      expect(
        JsonMapper.string(<String, dynamic>{'name': 'Kicau'}, 'name'),
        'Kicau',
      );
    });

    test('menolak field kosong, salah tipe, atau tidak ada', () {
      expectInvalid(() {
        JsonMapper.string(<String, dynamic>{'name': ''}, 'name');
      });
      expectInvalid(() {
        JsonMapper.string(<String, dynamic>{'name': 1}, 'name');
      });
      expectInvalid(() {
        JsonMapper.string(<String, dynamic>{}, 'name');
      });
    });
  });

  group('JsonMapper.strings', () {
    test('mengambil daftar teks', () {
      expect(
        JsonMapper.strings(<String, dynamic>{
          'items': ['MK', 'BN'],
        }, 'items'),
        <String>['MK', 'BN'],
      );
    });

    test('menolak daftar berisi elemen bukan teks atau teks kosong', () {
      expectInvalid(() {
        JsonMapper.strings(<String, dynamic>{
          'items': ['MK', 1],
        }, 'items');
      });
      expectInvalid(() {
        JsonMapper.strings(<String, dynamic>{
          'items': ['MK', ''],
        }, 'items');
      });
    });

    test('menolak nilai bukan daftar', () {
      expectInvalid(() {
        JsonMapper.strings(<String, dynamic>{'items': 'MK'}, 'items');
      });
    });
  });

  group('JsonMapper.integer', () {
    test('mengambil bilangan bulat', () {
      expect(JsonMapper.integer(<String, dynamic>{'count': 14}, 'count'), 14);
    });

    test('menolak nilai bukan bilangan bulat', () {
      expectInvalid(() {
        JsonMapper.integer(<String, dynamic>{'count': '14'}, 'count');
      });
    });
  });

  group('JsonMapper.list', () {
    test('mengambil daftar', () {
      expect(
        JsonMapper.list(<String, dynamic>{
          'items': [1, 2],
        }, 'items'),
        <Object?>[1, 2],
      );
    });

    test('menolak nilai bukan daftar', () {
      expectInvalid(() {
        JsonMapper.list(<String, dynamic>{'items': 1}, 'items');
      });
    });
  });

  group('JsonMapper.enumValue', () {
    test('mencocokkan nama enum', () {
      expect(
        JsonMapper.enumValue(
          <String, dynamic>{'category': 'muraiBatu'},
          'category',
          BirdCategory.values,
        ),
        BirdCategory.muraiBatu,
      );
    });

    test('menolak nama yang tidak dikenal', () {
      expectInvalid(() {
        JsonMapper.enumValue(
          <String, dynamic>{'category': 'unknown'},
          'category',
          BirdCategory.values,
        );
      });
    });
  });
}
