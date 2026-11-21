/// Wilayah arena untuk menyaring jadwal.
enum ScheduleRegion { all, jabodetabek, jawaBarat, jawaTengah, jawaTimur }

/// Jumlah arena aktif per wilayah.
typedef RegionCount = ({ScheduleRegion region, int arenas});
