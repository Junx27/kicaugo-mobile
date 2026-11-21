import '../../../../core/entities/bird_category.dart';

/// Event yang diterima [HomeBloc].
sealed class HomeEvent {
  const HomeEvent();
}

/// Beranda pertama kali dibuka.
final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// Pengguna meminta memuat ulang konten.
final class HomeRetryRequested extends HomeEvent {
  const HomeRetryRequested();
}

/// Pengguna memilih kategori burung untuk menyaring jadwal populer.
final class HomeCategorySelected extends HomeEvent {
  const HomeCategorySelected(this.category);

  final BirdCategory category;
}
