import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/location/location_service.dart';
import '../../../profile/domain/usecases/update_current_location.dart';
import '../../domain/usecases/get_home_content.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Memuat konten Beranda, menyimpan kategori terpilih, dan menyelaraskan
/// lokasi terkini secara best-effort.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._getHomeContent, {
    required LocationService locationService,
    required UpdateCurrentLocation updateCurrentLocation,
  }) : _locationService = locationService,
       _updateCurrentLocation = updateCurrentLocation,
       super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRetryRequested>(_onRetryRequested);
    on<HomeCategorySelected>(_onCategorySelected);
  }

  final GetHomeContent _getHomeContent;
  final LocationService _locationService;
  final UpdateCurrentLocation _updateCurrentLocation;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    await _load(
      emit,
      radiusKm: event.radiusKm,
      categoryId: event.categoryId,
      limit: event.limit,
    );
    await _syncLocation(emit, event);
  }

  Future<void> _onRetryRequested(
    HomeRetryRequested event,
    Emitter<HomeState> emit,
  ) => _load(
    emit,
    radiusKm: event.radiusKm,
    categoryId: event.categoryId,
    limit: event.limit,
  );

  void _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) => emit(state.withCategoryName(event.name));

  /// Lokasi terkini tidak boleh menggagalkan Beranda: izin ditolak, GPS mati,
  /// atau backend gagal cukup diabaikan dan konten tetap memakai fallback.
  Future<void> _syncLocation(Emitter<HomeState> emit, HomeStarted event) async {
    try {
      final location = await _locationService.readCurrentLocation();
      if (location == null) return;
      await _updateCurrentLocation(location);
    } catch (_) {
      return;
    }
    await _load(
      emit,
      radiusKm: event.radiusKm,
      categoryId: event.categoryId,
      limit: event.limit,
      silent: true,
    );
  }

  Future<void> _load(
    Emitter<HomeState> emit, {
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
    bool silent = false,
  }) async {
    if (!silent) {
      emit(
        HomeState(status: HomeStatus.loading, categoryName: state.categoryName),
      );
    }
    try {
      final content = await _getHomeContent(
        radiusKm: radiusKm,
        categoryId: categoryId,
        limit: limit,
      );
      emit(
        HomeState(
          status: HomeStatus.success,
          content: content,
          categoryName: state.categoryName,
        ),
      );
    } on Failure catch (failure) {
      if (silent) return;
      emit(
        HomeState(
          status: HomeStatus.failure,
          message: failure.message,
          categoryName: state.categoryName,
        ),
      );
    }
  }
}
