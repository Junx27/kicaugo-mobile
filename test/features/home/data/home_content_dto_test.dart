import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/error/failure.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_content_dto.dart';
import 'package:rumahkicau_mobile/features/home/data/datasources/home_data_source.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/bird_category_item.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_profile.dart';

import 'home_api_fixture.dart';

void main() {
  test('profileFromJson memetakan empat field payload baru', () {
    final profile = HomeContentDto.profileFromJson(homeProfilePayload());

    expect(profile, isA<HomeProfile>());
    expect(profile.name, 'Kicau Mania');
    expect(profile.greeting, 'Selamat siang');
    expect(profile.liveCount, 7);
    expect(profile.avatarUrl, 'https://example.com/avatar.png');
  });

  test('profileFromJson menerima avatar null', () {
    final profile = HomeContentDto.profileFromJson(
      homeProfilePayloadWithoutAvatar(),
    );

    expect(profile.avatarUrl, isNull);
  });

  test('featuredFromJson memetakan payload lomba unggulan', () {
    final featured = HomeContentDto.featuredFromJson(homeFeaturedPayload());

    expect(featured.title, 'Piala Raja Nusantara 2026');
    expect(featured.schedule, 'Minggu, 6 Des • Batavia Arena, Jaksel');
    expect(featured.distance, '3.2 KM');
    expect(featured.prize, 'Rp 50 Jt');
    expect(featured.slots, '12 Gantangan');
    expect(featured.attendees.initials, <String>['MK', 'BN']);
    expect(featured.attendees.others, 48);
  });

  test('birdCategoriesFromJson memetakan seluruh kategori dari envelope', () {
    final categories = HomeContentDto.birdCategoriesFromJson(
      homeBirdCategoriesPayload(),
    );

    expect(categories, HomeDemoDataSource.categories);
    expect(
      categories.first.icon,
      '${BirdCategoryItem.iconDirectory}murai_batu.svg',
    );
  });

  test(
    'birdCategoriesFromJson mempertahankan path ikon yang sudah lengkap',
    () {
      const fullPath = '${BirdCategoryItem.iconDirectory}murai_batu.svg';
      final categories = HomeContentDto.birdCategoriesFromJson(
        <String, dynamic>{
          'data': const <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 1,
              'name': 'Murai Batu',
              'slug': 'murai_batu',
              'icon': fullPath,
            },
          ],
        },
      );

      expect(categories.single.icon, fullPath);
    },
  );

  test('birdCategoriesFromJson menolak data yang bukan list', () {
    expect(
      () => HomeContentDto.birdCategoriesFromJson(<String, dynamic>{
        'data': 'bukan list',
      }),
      throwsA(isA<DataFailure>()),
    );
  });
}
