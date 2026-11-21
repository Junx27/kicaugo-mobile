import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/logging/pretty_json.dart';

void main() {
  test('JSON valid dicetak rapi dengan indentasi dua spasi', () {
    final result = prettyJson(<String, dynamic>{
      'name': 'KicauGo',
      'items': <Object>[1, 2],
    });

    expect(
      result,
      '{\n  "name": "KicauGo",\n  "items": [\n    1,\n    2\n  ]\n}',
    );
  });

  test('string JSON diurai dulu sebelum dicetak rapi', () {
    expect(
      prettyJson('{"status":200,"message":"OK"}'),
      '{\n  "status": 200,\n  "message": "OK"\n}',
    );
  });

  test('string bukan JSON dikembalikan apa adanya', () {
    expect(prettyJson('teks biasa'), 'teks biasa');
    expect(prettyJson('{"rusak":'), '{"rusak":');
  });

  test('objek tak serializable jatuh ke toString', () {
    expect(prettyJson(Object()), contains('Instance of'));
  });

  test('body lebih dari 4000 karakter dipotong', () {
    final long = 'x' * 4100;
    final result = truncateLogBody(prettyJson(<String, dynamic>{'data': long}));

    expect(result.endsWith('... (truncated)'), isTrue);
    expect(result.length, 4015);
  });

  test('body pendek tidak dipotong', () {
    expect(truncateLogBody('{"a":1}'), '{"a":1}');
  });

  test('kunci sensitif dikenali tanpa memperhatikan huruf besar', () {
    expect(isSensitiveLogKey('Authorization'), isTrue);
    expect(isSensitiveLogKey('note'), isFalse);
  });

  test('masking terjadi pada map sebelum pretty-print', () {
    final result = prettyMaskedJson(<String, dynamic>{
      'identifier': 'user@example.com',
      'password': 'rahasia',
      'token': 'jwt-value',
    });

    expect(
      result,
      '{\n'
      '  "identifier": "user@example.com",\n'
      '  "password": "***",\n'
      '  "token": "***"\n'
      '}',
    );
    expect(result, isNot(contains('rahasia')));
    expect(result, isNot(contains('jwt-value')));
  });

  test('string JSON ikut di-mask sebelum dicetak rapi', () {
    expect(
      prettyMaskedJson('{"password":"rahasia","note":"aman"}'),
      '{\n  "password": "***",\n  "note": "aman"\n}',
    );
  });

  test('masking menembus list bertingkat', () {
    expect(
      prettyMaskedJson(<String, dynamic>{
        'items': <Object>[
          <String, dynamic>{'secret': 'rahasia'},
          <String, dynamic>{'note': 'aman'},
        ],
      }),
      contains('"secret": "***"'),
    );
  });

  test('string non-JSON dan nilai lain tidak berubah saat di-mask', () {
    expect(maskSensitiveValues('teks biasa'), 'teks biasa');
    expect(maskSensitiveValues(42), 42);
  });
}
