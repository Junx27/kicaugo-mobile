import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/utils/timed_future.dart';
import '../../../profile/domain/usecases/update_current_location.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/usecases/get_home_content.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Sumber pemuatan konten Beranda.
///
/// Hanya [initial] dan [userRefresh] yang menampilkan shimmer; penyelarasan
/// lokasi bersifat best-effort dan tidak boleh mengganggu tampilan.
enum _HomeLoadMode { initial, userRefresh, locationSync }

/// Memuat konten Beranda, menyimpan kategori terpilih, dan menyelaraskan
/// lokasi terkini secara best-effort.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._getHomeContent, {
    required LocationService locationService,
    required UpdateCurrentLocation updateCurrentLocation,
    Duration loadTimeout = AppConstants.homeShimmerTimeout,
    Duration retryDelay = AppConstants.homeRetryDelay,
  }) : _locationService = locationService,
       _updateCurrentLocation = updateCurrentLocation,
       _loadTimeout = loadTimeout,
       _retryDelay = retryDelay,
       super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRetryRequested>(_onRetryRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeCategorySelected>(_onCategorySelected);
  }

  final GetHomeContent _getHomeContent;
  final LocationService _locationService;
  final UpdateCurrentLocation _updateCurrentLocation;
  final Duration _loadTimeout;
  final Duration _retryDelay;

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

  /// Refresh dari gestur tarik ke bawah: konten lama tetap tampil sampai data
  /// baru tersedia, dan indikator diberi tahu setelah percobaan selesai.
  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _load(emit, mode: _HomeLoadMode.userRefresh);
    } finally {
      if (!event.completer.isCompleted) event.completer.complete();
    }
  }

  void _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) => emit(state.withCategoryName(event.name));

  /// Lokasi terkini tidak boleh menggagalkan Beranda: izin ditolak, GPS mati,
  /// atau backend gagal cukup diabaikan tanpa mengubah konten yang sudah ada.
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
      mode: _HomeLoadMode.locationSync,
    );
  }

  Future<void> _load(
    Emitter<HomeState> emit, {
    int radiusKm = 1,
    int categoryId = 1,
    int limit = 5,
    _HomeLoadMode mode = _HomeLoadMode.initial,
  }) async {
    if (mode != _HomeLoadMode.locationSync) {
      emit(
        mode == _HomeLoadMode.initial
            ? HomeState(
                status: HomeStatus.loading,
                categoryName: state.categoryName,
                isFetching: true,
              )
            : state.copyWith(isFetching: true),
      );
    }
    const timeoutError = DataFailure(AppConstants.homeLoadTimeout);
    Future<HomeContent> fetch() => _getHomeContent(
      radiusKm: radiusKm,
      categoryId: categoryId,
      limit: limit,
    );

    try {
      // Selama shimmer tampil, kegagalan sesaat dicoba ulang. Refresh pasca
      // lokasi tetap best-effort: satu percobaan tanpa retry.
      final content = mode == _HomeLoadMode.initial
          ? await retryUntilTimeout(
              operation: fetch,
              timeout: _loadTimeout,
              retryDelay: _retryDelay,
              timeoutError: timeoutError,
            )
          : await withTimeout(fetch(), _loadTimeout, timeoutError);
      // Refresh tidak boleh menimpa keadaan gagal yang sudah menampilkan
      // tombol coba lagi.
      if (state.status == HomeStatus.failure) return;
      emit(
        HomeState(
          status: HomeStatus.success,
          content: content,
          categoryName: state.categoryName,
        ),
      );
    } on Failure catch (failure) {
      if (mode == _HomeLoadMode.locationSync) return;
      if (mode == _HomeLoadMode.userRefresh) {
        emit(state.copyWith(isFetching: false));
        return;
      }
      emit(
        HomeState(
          status: HomeStatus.failure,
          message: failure.message,
          categoryName: state.categoryName,
        ),
      );
    } finally {
      // Pengambilan data selesai, gagal, atau dibatalkan: shimmer harus mati.
      if (state.isFetching) emit(state.copyWith(isFetching: false));
    }
  }
}
