import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/reminders/data/datasources/fake_reminders_data_source.dart';
import 'package:rumahkicau_mobile/features/reminders/data/repositories/reminders_repository_impl.dart';
import 'package:rumahkicau_mobile/features/reminders/domain/usecases/get_reminders_content.dart';

import '../reminders_fakes.dart';

void main() {
  test('fake data source mengembalikan konten pengingat lengkap', () async {
    const dataSource = FakeRemindersDataSource(delay: Duration.zero);
    final content = await dataSource.fetchReminders();

    expect(content, same(FakeRemindersDataSource.content));
    expect(content.birds, hasLength(3));
    expect(content.careReminders, hasLength(4));
    expect(content.careReminders.where((item) => item.isDone), hasLength(2));
    expect(content.contest.reminders, hasLength(2));
    expect(content.settings.ringtone, 'Suara Masteran Cililin HD');
  });

  test('fake data source menunggu delay sebelum mengembalikan data', () async {
    const dataSource = FakeRemindersDataSource(
      delay: Duration(milliseconds: 1),
    );
    final content = await dataSource.fetchReminders();

    expect(content.contest.venue, 'Batavia Arena');
    expect(content.contest.countdown, 'H-2 Hari');
  });

  test('repository meneruskan konten dari data source', () async {
    const repository = RemindersRepositoryImpl(
      FakeRemindersDataSource(delay: Duration.zero),
    );

    final content = await repository.fetchReminders();

    expect(content.birds.last.name, 'Rawa Rontek');
    expect(content.careReminders.last.contestEveOnly, isTrue);
  });

  test('usecase memanggil repository', () async {
    final repository = FakeRemindersRepository();
    final content = await GetRemindersContent(repository)();

    expect(repository.fetchCalls, 1);
    expect(content, same(sampleReminders));
  });
}
