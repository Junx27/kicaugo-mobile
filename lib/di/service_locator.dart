import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/location/geolocator_location_service.dart';
import '../core/location/location_service.dart';
import '../core/network/api_client.dart';
import '../core/network/api_logging_interceptor.dart';
import '../core/routing/osrm_route_service.dart';
import '../core/routing/route_service.dart';
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
import '../features/event/data/datasources/api_contest_detail_data_source.dart';
import '../features/event/data/datasources/contest_detail_data_source.dart';
import '../features/event/data/datasources/fake_contest_detail_data_source.dart';
import '../features/event/data/repositories/contest_detail_repository_impl.dart';
import '../features/event/domain/repositories/contest_detail_repository.dart';
import '../features/event/domain/usecases/get_contest_detail.dart';
import '../features/home/data/datasources/api_home_data_source.dart';
import '../features/home/data/datasources/home_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_home_content.dart';
import '../features/profile/data/datasources/api_current_location_data_source.dart';
import '../features/profile/data/datasources/current_location_data_source.dart';
import '../features/profile/data/repositories/current_location_repository_impl.dart';
import '../features/profile/domain/repositories/current_location_repository.dart';
import '../features/profile/domain/usecases/update_current_location.dart';

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
      ..registerLazySingleton<HomeDataSource>(() => ApiHomeDataSource(getIt()))
      ..registerLazySingleton<ContestDetailDataSource>(
        () => ApiContestDetailDataSource(getIt()),
      )
      ..registerLazySingleton<LocationService>(
        () => const GeolocatorLocationService(),
      )
      ..registerLazySingleton<CurrentLocationDataSource>(
        () => ApiCurrentLocationDataSource(getIt()),
      );
  } else {
    getIt
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => FakeAuthRemoteDataSource(),
      )
      ..registerLazySingleton<HomeDataSource>(() => const HomeDemoDataSource())
      ..registerLazySingleton<ContestDetailDataSource>(
        () => const FakeContestDetailDataSource(),
      )
      ..registerLazySingleton<LocationService>(() => const NoLocationService())
      ..registerLazySingleton<CurrentLocationDataSource>(
        () => const NoOpCurrentLocationDataSource(),
      );
  }

  // Rute peta tidak bergantung pada backend sendiri, jadi selalu tersedia.
  getIt.registerLazySingleton<RouteService>(() => OsrmRouteService());

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
    ..registerLazySingleton(() => GetHomeContent(getIt()))
    ..registerLazySingleton<ContestDetailRepository>(
      () => ContestDetailRepositoryImpl(getIt()),
    )
    ..registerLazySingleton(() => GetContestDetail(getIt()))
    ..registerLazySingleton<CurrentLocationRepository>(
      () => CurrentLocationRepositoryImpl(getIt()),
    )
    ..registerLazySingleton(() => UpdateCurrentLocation(getIt()));
}
