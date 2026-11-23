import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../error/failure.dart';
import 'api_failure_mapper.dart';
import 'token_provider.dart';

const String _authorizationHeader = 'Authorization';
const String _bearerPrefix = 'Bearer ';

/// Klien HTTP bersama: menyisipkan token, memetakan error, dan mengurai JSON.
class ApiClient {
  ApiClient(this._dio, this._tokens);

  final Dio _dio;
  final TokenProvider _tokens;

  Future<Map<String, dynamic>> getJson(String path) async {
    final response = await _send(
      (options) => _dio.get<dynamic>(path, options: options),
    );
    return decodeEnvelope(response.data);
  }

  Future<Map<String, dynamic>> postJson(String path, {Object? body}) async {
    final response = await _send(
      (options) => _dio.post<dynamic>(path, data: body, options: options),
    );
    return decodeEnvelope(response.data);
  }

  Future<Map<String, dynamic>> putJson(String path, {Object? body}) async {
    final response = await _send(
      (options) => _dio.put<dynamic>(path, data: body, options: options),
    );
    return decodeEnvelope(response.data);
  }

  Future<void> postEmpty(String path) async {
    await _send((options) => _dio.post<dynamic>(path, options: options));
  }

  Future<Response<dynamic>> _send(
    Future<Response<dynamic>> Function(Options options) request,
  ) async {
    try {
      final token = await _tokens.readToken();
      final options = Options(
        headers: <String, dynamic>{
          if (token != null && token.isNotEmpty)
            _authorizationHeader: '$_bearerPrefix$token',
        },
      );
      return await request(options);
    } on DioException catch (error) {
      throw mapDioException(error);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const DataFailure(AppConstants.apiUnexpected);
    }
  }
}

/// Mengurai body JSON menjadi map, atau melempar [DataFailure].
Map<String, dynamic> decodeJson(Object? data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  throw const DataFailure(AppConstants.apiInvalidResponse);
}

/// Membuka envelope standar backend `{status, message, data}`.
///
/// Response datar tanpa `data` tetap diterima agar kontrak lama tidak rusak.
Map<String, dynamic> decodeEnvelope(Object? value) {
  final json = decodeJson(value);
  final data = json['data'];
  if (data is Map) return Map<String, dynamic>.from(data);
  return json;
}
