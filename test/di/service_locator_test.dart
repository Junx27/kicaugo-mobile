import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/location/geolocator_location_service.dart';
import 'package:rumahkicau_mobile/core/location/location_service.dart';
import 'package:rumahkicau_mobile/core/network/api_client.dart';
import 'package:rumahkicau_mobile/core/routing/osrm_route_service.dart';
import 'package:rumahkicau_mobile/core/routing/route_service.dart';
import 'package:rumahkicau_mobile/di/service_locator.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/api_auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/api_home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';
import 'package:rumahkicau_mobile/features/profile/data/datasources/api_current_location_data_source.dart';
import 'package:rumahkicau_mobile/features/profile/data/datasources/current_location_data_source.dart';
import 'package:rumahkicau_mobile/features/profile/domain/repositories/current_location_repository.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/update_current_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() async {
    await getIt.reset();
  });

  test('merakit seluruh dependency aplikasi', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await configureDependencies();

    expect(getIt<AuthRemoteDataSource>(), isA<FakeAuthRemoteDataSource>());
    expect(getIt<AuthRepository>(), isNotNull);
    expect(getIt<LoginUseCase>(), isNotNull);
    expect(getIt<RegisterUseCase>(), isNotNull);
    expect(getIt<LogoutUseCase>(), isNotNull);
    expect(getIt<AuthBloc>(), isA<AuthBloc>());
    expect(getIt<HomeDataSource>(), isA<HomeDemoDataSource>());
    expect(getIt<HomeRepository>(), isNotNull);
    expect(getIt<GetHomeContent>(), isNotNull);
    expect(getIt<LocationService>(), isA<NoLocationService>());
    expect(
      getIt<CurrentLocationDataSource>(),
      isA<NoOpCurrentLocationDataSource>(),
    );
    expect(getIt<CurrentLocationRepository>(), isNotNull);
    expect(getIt<UpdateCurrentLocation>(), isNotNull);
    // Rute peta tersedia juga di mode demo karena tidak bergantung backend.
    expect(getIt<RouteService>(), isA<OsrmRouteService>());
  });

  test('flag useApi merakit data source API', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await configureDependencies(useApi: true);

    expect(getIt<AuthRemoteDataSource>(), isA<ApiAuthRemoteDataSource>());
    expect(getIt<HomeDataSource>(), isA<ApiHomeDataSource>());
    expect(getIt<ApiClient>(), isNotNull);
    expect(getIt<LocationService>(), isA<GeolocatorLocationService>());
    expect(
      getIt<CurrentLocationDataSource>(),
      isA<ApiCurrentLocationDataSource>(),
    );
  });

  test('reset menutup AuthBloc yang sudah dibuat', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await configureDependencies();
    final bloc = getIt<AuthBloc>();

    await getIt.reset();

    expect(bloc.isClosed, isTrue);
  });
}
