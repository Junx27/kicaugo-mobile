import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/profile/data/datasources/fake_profile_data_source.dart';
import 'package:rumahkicau_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:rumahkicau_mobile/features/profile/domain/entities/profile_content.dart';
import 'package:rumahkicau_mobile/features/profile/domain/usecases/get_profile_content.dart';

import '../profile_fakes.dart';

void main() {
  test('fake data source mengembalikan tiga burung dan satu hero', () async {
    const dataSource = FakeProfileDataSource(delay: Duration.zero);
    final content = await dataSource.fetchProfileContent();

    expect(content, same(FakeProfileDataSource.content));
    expect(content.birds, hasLength(3));
    expect(content.birds.where((bird) => bird.isHero), hasLength(1));
    expect(content.birds.first.careSlots, hasLength(3));
  });

  test('fake data source menunggu delay sebelum mengembalikan data', () async {
    const dataSource = FakeProfileDataSource(delay: Duration(milliseconds: 1));
    final content = await dataSource.fetchProfileContent();

    expect(content.member.club, 'Batavia SF');
    expect(content.stats.balance, 'Rp 1.450.000');
  });

  test('repository meneruskan konten dari data source', () async {
    const repository = ProfileRepositoryImpl(
      FakeProfileDataSource(delay: Duration.zero),
    );

    final content = await repository.fetchProfileContent();

    expect(content.stats.trophies, 14);
    expect(content.birds.last.name, 'Rawa Rontek');
  });

  test('usecase memanggil repository', () async {
    final repository = FakeProfileRepository();
    final usecase = GetProfileContent(repository);

    final content = await usecase();

    expect(repository.fetchCalls, 1);
    expect(content, same(sampleProfile));
  });

  test('entity membandingkan seluruh properti', () {
    final member = sampleProfile.member;
    final stats = sampleProfile.stats;
    final bird = sampleProfile.birds.first;

    expect(
      member,
      ProfileMember(
        avatarUrl: member.avatarUrl,
        club: member.club,
        memberId: member.memberId,
        memberSince: member.memberSince,
        isVerified: member.isVerified,
      ),
    );
    expect(
      stats,
      ProfileStats(
        trophies: stats.trophies,
        medals: stats.medals,
        attendance: stats.attendance,
        birdsReady: stats.birdsReady,
        balance: stats.balance,
      ),
    );
    expect(
      bird,
      ProfileBird(
        name: bird.name,
        species: bird.species,
        ringId: bird.ringId,
        status: bird.status,
        imageUrl: bird.imageUrl,
        highlight: bird.highlight,
        isHero: bird.isHero,
        footerNote: bird.footerNote,
        careSlots: bird.careSlots,
      ),
    );
    expect(
      sampleProfile,
      ProfileContent(member: member, stats: stats, birds: sampleProfile.birds),
    );
  });
}
