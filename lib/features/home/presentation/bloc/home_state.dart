import 'package:equatable/equatable.dart';

import '../../../../core/entities/bird_category.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/entities/schedule_item.dart';

/// Status pemuatan Beranda.
enum HomeStatus { initial, loading, success, failure }

/// State yang dibaca halaman Beranda.
class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.content,
    this.message,
    this.category = BirdCategory.all,
  });

  final HomeStatus status;
  final HomeContent? content;
  final String? message;
  final BirdCategory category;

  /// Jadwal populer sesuai kategori terpilih.
  List<ScheduleItem> get visibleSchedules {
    final schedules = content?.schedules ?? const <ScheduleItem>[];
    if (category == BirdCategory.all) {
      return schedules;
    }
    return schedules.where((item) => item.category == category).toList();
  }

  /// Salinan state dengan kategori jadwal [category].
  HomeState withCategory(BirdCategory category) => HomeState(
    status: status,
    content: content,
    message: message,
    category: category,
  );

  @override
  List<Object?> get props => [status, content, message, category];
}
