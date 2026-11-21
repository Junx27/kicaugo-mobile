import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_logging_interceptor.dart';
import '../features/auth/data/datasources/api_auth_remote_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/datasources/fake_auth_remote_data_source.dart';
import '../features/auth/data/datasources/session_storage.dart';
import '../features/auth/data/datasources/shared_preferences_session_storage.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/data/datasources/api_home_data_source.dart';
import '../features/home/data/datasources/fake_home_data_source.dart';
import '../features/home/data/datasources/home_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_home_content.dart';

/// Service locator aplikasi.
final GetIt getIt = GetIt.instance;

/// Merakit dependency dari layer terluar ke terdalam.
///
/// [useApi] mengambil alih flag bawaan untuk keperluan test.
Future<void> configureDependencies({bool? useApi}) async {
  final prefs = await SharedPreferences.getInstance();
  final sessionStorage = SharedPreferencesSessionStorage(prefs);
  final initialUser = await sessionStorage.readSession();
  final remote = useApi ?? AppConstants.useApi;

  getIt
    ..registerLazySingleton<SharedPreferences>(() => prefs)
    ..registerLazySingleton<SessionStorage>(() => sessionStorage);

  if (remote) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
      ),
    );
    dio.interceptors.add(ApiLoggingInterceptor());
    getIt
      ..registerLazySingleton<ApiClient>(
        () => ApiClient(dio, getIt<SessionStorage>()),
      )
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => ApiAuthRemoteDataSource(getIt()),
      )
      ..registerLazySingleton<HomeDataSource>(() => ApiHomeDataSource(getIt()));
  } else {
    getIt
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => FakeAuthRemoteDataSource(),
      )
      ..registerLazySingleton<HomeDataSource>(() => const FakeHomeDataSource());
  }

  getIt
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()))
    ..registerLazySingleton(() => LoginUseCase(getIt()))
    ..registerLazySingleton(() => RegisterUseCase(getIt()))
    ..registerLazySingleton(() => LogoutUseCase(getIt()))
    ..registerLazySingleton(
      () => AuthBloc(
        login: getIt(),
        register: getIt(),
        logout: getIt(),
        sessionStorage: getIt<SessionStorage>(),
        initialUser: initialUser,
      ),
      dispose: (bloc) => bloc.close(),
    )
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt()))
    ..registerLazySingleton(() => GetHomeContent(getIt()));
}
