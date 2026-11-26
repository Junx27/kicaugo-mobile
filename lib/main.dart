import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/location/location_service.dart';
import 'core/logging/app_logger.dart';
import 'core/routing/route_service.dart';
import 'di/service_locator.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/event/domain/usecases/get_contest_detail.dart';
import 'features/home/domain/usecases/get_home_content.dart';
import 'features/profile/domain/usecases/update_current_location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  _registerFontLicenses();
  await configureDependencies();
  AppLogger.log(
    'BOOT',
    'flavor=${AppConstants.flavor.name} '
        'baseUrl=${AppConstants.apiBaseUrl} '
        'useApi=${AppConstants.useApi}',
    icon: '🟢',
  );
  runApp(
    KicauKuApp(
      authBloc: getIt<AuthBloc>(),
      getHomeContent: getIt<GetHomeContent>(),
      getContestDetail: getIt<GetContestDetail>(),
      locationService: getIt<LocationService>(),
      routeService: getIt<RouteService>(),
      updateCurrentLocation: getIt<UpdateCurrentLocation>(),
    ),
  );
}

/// Mendaftarkan lisensi SIL OFL font yang di-bundle.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final path in AppConstants.fontLicenseAssets) {
      final license = await rootBundle.loadString(path);
      yield LicenseEntryWithLineBreaks(const <String>['google_fonts'], license);
    }
  });
}
