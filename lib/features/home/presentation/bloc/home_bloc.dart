import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_home_content.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Memuat konten Beranda dan menyimpan kategori jadwal yang dipilih.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomeContent) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRetryRequested>(_onRetryRequested);
    on<HomeCategorySelected>(_onCategorySelected);
  }

  final GetHomeContent _getHomeContent;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) =>
      _load(emit);

  Future<void> _onRetryRequested(
    HomeRetryRequested event,
    Emitter<HomeState> emit,
  ) => _load(emit);

  void _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) => emit(state.withCategory(event.category));

  Future<void> _load(Emitter<HomeState> emit) async {
    emit(HomeState(status: HomeStatus.loading, category: state.category));
    try {
      final content = await _getHomeContent();
      emit(
        HomeState(
          status: HomeStatus.success,
          content: content,
          category: state.category,
        ),
      );
    } on Failure catch (failure) {
      emit(
        HomeState(
          status: HomeStatus.failure,
          message: failure.message,
          category: state.category,
        ),
      );
    }
  }
}
