import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/datasources/fake_auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/data/datasources/fake_home_data_source.dart';
import '../features/home/data/datasources/home_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_home_content.dart';

/// Service locator aplikasi.
final GetIt getIt = GetIt.instance;

/// Merakit dependency dari layer terluar ke terdalam.
void configureDependencies() {
  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => FakeAuthRemoteDataSource(),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()))
    ..registerLazySingleton(() => LoginUseCase(getIt()))
    ..registerLazySingleton(() => RegisterUseCase(getIt()))
    ..registerLazySingleton(() => LogoutUseCase(getIt()))
    ..registerLazySingleton(
      () => AuthBloc(login: getIt(), register: getIt(), logout: getIt()),
      dispose: (bloc) => bloc.close(),
    )
    ..registerLazySingleton<HomeDataSource>(() => const FakeHomeDataSource())
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt()))
    ..registerLazySingleton(() => GetHomeContent(getIt()));
}
