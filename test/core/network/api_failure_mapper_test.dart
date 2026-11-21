import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/constants/app_constants.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/core/network/api_failure_mapper.dart';

DioException buildError({
  int? statusCode,
  Object? data,
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  final options = RequestOptions(path: '/api/v1/test');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  group('mapDioException', () {
    test('401 memakai pesan dari server', () {
      final failure = mapDioException(
        buildError(
          statusCode: 401,
          data: <String, dynamic>{
            'error': <String, dynamic>{'message': 'Kredensial salah'},
          },
        ),
      );

      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Kredensial salah');
    });

    test('401 memakai pesan root dari backend', () {
      final failure = mapDioException(
        buildError(
          statusCode: 401,
          data: <String, dynamic>{
            'status': 401,
            'message': 'Invalid email/WhatsApp or password',
            'data': null,
          },
        ),
      );

      expect(failure.message, 'Invalid email/WhatsApp or password');
    });

    test('403 tanpa pesan memakai pesan bawaan', () {
      final failure = mapDioException(buildError(statusCode: 403));

      expect(failure, isA<AuthFailure>());
      expect(failure.message, AppConstants.apiUnauthorized);
    });

    test('500 memakai pesan dari server', () {
      final failure = mapDioException(
        buildError(
          statusCode: 500,
          data: <String, dynamic>{
            'error': <String, dynamic>{'message': 'Database down'},
          },
        ),
      );

      expect(failure, isA<DataFailure>());
      expect(failure.message, 'Database down');
    });

    test('400 tanpa pesan memakai pesan bawaan', () {
      final failure = mapDioException(buildError(statusCode: 400));

      expect(failure, isA<DataFailure>());
      expect(failure.message, AppConstants.apiDataFailure);
    });

    test('timeout memakai pesan timeout', () {
      for (final type in <DioExceptionType>[
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final failure = mapDioException(buildError(type: type));
        expect(failure, isA<DataFailure>());
        expect(failure.message, AppConstants.apiTimeoutMessage);
      }
    });

    test('kesalahan lain memakai pesan koneksi', () {
      final failure = mapDioException(
        buildError(type: DioExceptionType.connectionError),
      );

      expect(failure, isA<DataFailure>());
      expect(failure.message, AppConstants.apiConnection);
    });
  });

  group('serverMessage', () {
    test('mengambil pesan dari struktur error', () {
      expect(
        serverMessage(<String, dynamic>{
          'error': <String, dynamic>{'message': 'Gagal'},
        }),
        'Gagal',
      );
    });

    test('mengambil pesan dari root response backend', () {
      expect(
        serverMessage(<String, dynamic>{
          'status': 401,
          'message': 'Invalid email/WhatsApp or password',
          'data': null,
        }),
        'Invalid email/WhatsApp or password',
      );
    });

    test('null untuk bentuk yang tidak dikenal', () {
      expect(serverMessage(null), isNull);
      expect(serverMessage('teks'), isNull);
      expect(serverMessage(<String, dynamic>{}), isNull);
      expect(
        serverMessage(<String, dynamic>{'error': <String, dynamic>{}}),
        isNull,
      );
      expect(
        serverMessage(<String, dynamic>{
          'error': <String, dynamic>{'message': 1},
        }),
        isNull,
      );
      expect(
        serverMessage(<String, dynamic>{
          'error': <String, dynamic>{'message': ''},
        }),
        isNull,
      );
    });
  });
}
