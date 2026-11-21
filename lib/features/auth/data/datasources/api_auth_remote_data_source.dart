import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_paths.dart';
import '../../../../core/network/json_mapper.dart';
import '../../domain/entities/user.dart';
import 'auth_remote_data_source.dart';

/// Sumber data autentikasi yang memakai backend KicauGo.
class ApiAuthRemoteDataSource implements AuthRemoteDataSource {
  const ApiAuthRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<User> login({
    required String identifier,
    required String password,
  }) async {
    final json = await _client.postJson(
      ApiPaths.login,
      body: <String, dynamic>{'identifier': identifier, 'password': password},
    );
    return readAuthUser(json);
  }

  @override
  Future<User> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    final json = await _client.postJson(
      ApiPaths.register,
      body: <String, dynamic>{
        'name': name,
        'identifier': identifier,
        'password': password,
      },
    );
    return readAuthUser(json);
  }

  @override
  Future<void> logout() => _client.postEmpty(ApiPaths.logout);
}

/// Mengubah payload `AuthResponse` menjadi [User] beserta tokennya.
User readAuthUser(Map<String, dynamic> json) {
  final payload = JsonMapper.object(json['user']);
  return User(
    name: JsonMapper.string(payload, 'name'),
    identifier: JsonMapper.string(payload, 'identifier'),
    token: JsonMapper.string(json, 'token'),
  );
}
