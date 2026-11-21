import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:rumahkicau_mobile/core/network/token_provider.dart';

/// Token provider palsu untuk test lapisan jaringan.
class FakeTokenProvider implements TokenProvider {
  FakeTokenProvider(this.token);

  String? token;

  @override
  Future<String?> readToken() async => token;
}

/// Token provider yang selalu gagal, untuk menguji jalur error tak dikenal.
class ThrowingTokenProvider implements TokenProvider {
  @override
  Future<String?> readToken() async => throw StateError('storage down');
}

/// Adapter Dio yang mengembalikan respons tertentu tanpa membuka jaringan.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter({this.statusCode = 200, this.body = '{}', this.exception});

  int statusCode;
  String body;
  Object? exception;

  RequestOptions? recordedOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    recordedOptions = options;
    if (exception != null) throw exception!;
    final headers = <String, List<String>>{};
    if (body.isNotEmpty) {
      headers[Headers.contentTypeHeader] = <String>[Headers.jsonContentType];
    }
    return ResponseBody.fromString(body, statusCode, headers: headers);
  }

  @override
  void close({bool force = false}) {}
}

/// Membuat Dio yang memakai [adapter] sebagai transport.
Dio testDio(FakeHttpAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://localhost'))..httpClientAdapter = adapter;

/// Mengambil body request yang tercatat, baik sudah berupa Map maupun JSON.
Map<String, dynamic> recordedBody(FakeHttpAdapter adapter) {
  final data = adapter.recordedOptions?.data;
  if (data is String) return jsonDecode(data) as Map<String, dynamic>;
  return Map<String, dynamic>.from(data as Map);
}
