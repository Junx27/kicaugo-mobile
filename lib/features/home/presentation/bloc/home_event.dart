/// Event yang diterima [HomeBloc].
sealed class HomeEvent {
  const HomeEvent();
}

/// Beranda pertama kali dibuka.
final class HomeStarted extends HomeEvent {
  const HomeStarted({this.radiusKm = 1, this.categoryId = 1, this.limit = 5});

  final int radiusKm;
  final int categoryId;
  final int limit;
}

/// Pengguna meminta memuat ulang konten.
final class HomeRetryRequested extends HomeEvent {
  const HomeRetryRequested({
    this.radiusKm = 1,
    this.categoryId = 1,
    this.limit = 5,
  });

  final int radiusKm;
  final int categoryId;
  final int limit;
}

/// Pengguna memilih kategori burung untuk menyaring jadwal populer.
final class HomeCategorySelected extends HomeEvent {
  const HomeCategorySelected(this.name);

  /// Nama kategori dari endpoint bird-categories, atau "Semua Lomba".
  final String name;
}
