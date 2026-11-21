import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/di/service_locator.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/data/datasources/fake_auth_remote_data_source.dart';
import 'package:rumahkicau_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:rumahkicau_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/fake_home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:rumahkicau_mobile/features/home/domain/usecases/get_home_content.dart';
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
    expect(getIt<HomeDataSource>(), isA<FakeHomeDataSource>());
    expect(getIt<HomeRepository>(), isNotNull);
    expect(getIt<GetHomeContent>(), isNotNull);
  });

  test('reset menutup AuthBloc yang sudah dibuat', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await configureDependencies();
    final bloc = getIt<AuthBloc>();

    await getIt.reset();

    expect(bloc.isClosed, isTrue);
  });
}
