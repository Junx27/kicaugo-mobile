import 'dart:convert';

import 'package:dio/dio.dart';

import '../logging/app_logger.dart';
import '../logging/pretty_json.dart';

const String _tag = 'API';
const String _errorTag = 'ERR';
const String _mask = '***';

/// Interceptor Dio yang mencatat request, payload, dan response di debug.
class ApiLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.log(_tag, 'REQUEST ${options.method} ${options.uri}', icon: '🌐');
    _logHeaders(options.headers);

    if (options.data != null) {
      AppLogger.log(_tag, 'PAYLOAD\n${_body(options.data)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final request = response.requestOptions;
    final status = response.statusCode ?? 0;
    AppLogger.log(
      _tag,
      'RESPONSE $status ${request.method} ${request.uri}\n'
      '${_body(response.data)}',
      colorCode: _isSuccess(status) ? AppLogger.green : AppLogger.red,
      icon: _isSuccess(status) ? '✅' : '❌',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    AppLogger.log(
      _errorTag,
      'ERROR ${err.response?.statusCode} ${request.method} ${request.uri} '
      'message=${err.message}\n${_body(err.response?.data)}',
      icon: '❌',
    );
    handler.next(err);
  }

  /// Mencatat header dengan nilai sensitif yang sudah di-mask.
  void _logHeaders(Map<String, dynamic> headers) {
    final visible = <String, dynamic>{
      for (final entry in headers.entries)
        entry.key: isSensitiveLogKey(entry.key) ? _mask : entry.value,
    };
    AppLogger.log(_tag, 'HEADERS ${_encode(visible)}', icon: '📤');
  }

  /// Body aman, rapi, dan dipotong bila terlalu panjang.
  String _body(Object? data) {
    if (data == null) return '';
    return truncateLogBody(prettyMaskedJson(data));
  }

  /// Mengubah objek menjadi teks, dengan fallback bila tidak serializable.
  String _encode(Object? value) {
    try {
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }

  /// Status 2xx ditandai sukses.
  bool _isSuccess(int status) => status >= 200 && status < 300;
}
