import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../error/failure.dart';

/// Mengubah kesalahan Dio menjadi [Failure] yang bisa ditampilkan ke pengguna.
Failure mapDioException(DioException error) {
  final statusCode = error.response?.statusCode ?? 0;
  final message = serverMessage(error.response?.data);
  return switch (statusCode) {
    401 || 403 => AuthFailure(message ?? AppConstants.apiUnauthorized),
    >= 400 => DataFailure(message ?? AppConstants.apiDataFailure),
    _ => _networkFailure(error.type),
  };
}

/// Mengambil pesan aman dari `error.message` atau `message` di root.
String? serverMessage(Object? data) {
  if (data is! Map) return null;
  final error = data['error'];
  final source = error is Map ? error : data;
  final message = source['message'];
  return message is String && message.isNotEmpty ? message : null;
}

Failure _networkFailure(DioExceptionType type) {
  return switch (type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const DataFailure(
      AppConstants.apiTimeoutMessage,
    ),
    _ => const DataFailure(AppConstants.apiConnection),
  };
}
