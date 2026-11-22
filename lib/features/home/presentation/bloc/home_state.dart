import 'package:equatable/equatable.dart';

import '../../../../core/widgets/bird_category_style.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/entities/schedule_item.dart';
import '../home_strings.dart';

/// Status pemuatan Beranda.
enum HomeStatus { initial, loading, success, failure }

/// State yang dibaca halaman Beranda.
class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.content,
    this.message,
    this.categoryName = HomeStrings.allCategories,
  });

  final HomeStatus status;
  final HomeContent? content;
  final String? message;
  final String categoryName;

  /// Jadwal populer sesuai nama kategori terpilih.
  List<ScheduleItem> get visibleSchedules {
    final schedules = content?.schedules ?? const <ScheduleItem>[];
    if (categoryName == HomeStrings.allCategories) {
      return schedules;
    }
    return schedules
        .where((item) => item.category.label == categoryName)
        .toList();
  }

  /// Salinan state dengan nama kategori jadwal [categoryName].
  HomeState withCategoryName(String categoryName) => HomeState(
    status: status,
    content: content,
    message: message,
    categoryName: categoryName,
  );

  @override
  List<Object?> get props => [status, content, message, categoryName];
}
