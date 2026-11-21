import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/schedule/data/datasources/fake_schedule_data_source.dart';
import 'package:rumahkicau_mobile/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/usecases/get_schedule_content.dart';

void main() {
  test('usecase dan repository meneruskan konten demo', () async {
    const usecase = GetScheduleContent(
      ScheduleRepositoryImpl(FakeScheduleDataSource(delay: Duration.zero)),
    );

    final content = await usecase();

    expect(content, FakeScheduleDataSource.content);
    expect(content.days, hasLength(7));
    expect(content.peakDay, DateTime(2026, 11, 22));
    expect(content.featured.headline.title, isNotEmpty);
  });

  test('tanggal demo berada di pekan 16-22 Nov 2026', () {
    final content = FakeScheduleDataSource.content;

    expect(content.days.first.date.weekday, DateTime.monday);
    expect(content.days.last.date.weekday, DateTime.sunday);
    for (final agenda in content.agendas) {
      expect(agenda.slot.date.isBefore(DateTime(2026, 11, 23)), isTrue);
      expect(agenda.slot.date.isAfter(DateTime(2026, 11, 15)), isTrue);
    }
  });
}
