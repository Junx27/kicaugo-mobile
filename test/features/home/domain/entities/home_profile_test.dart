import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/home_profile.dart';

const String displayName = 'Kicau Mania';
const String greetingText = 'Selamat siang';
const String avatarUrl = 'https://example.com/avatar.png';

void main() {
  test('HomeProfile menyimpan keempat field payload profile', () {
    const profile = HomeProfile(
      name: displayName,
      avatarUrl: avatarUrl,
      greeting: greetingText,
      liveCount: 7,
    );

    expect(profile.name, displayName);
    expect(profile.avatarUrl, avatarUrl);
    expect(profile.greeting, greetingText);
    expect(profile.liveCount, 7);
  });

  test('HomeProfile memakai semua field dalam equality', () {
    const profile = HomeProfile(
      name: displayName,
      greeting: greetingText,
      liveCount: 7,
    );

    expect(
      profile,
      const HomeProfile(
        name: displayName,
        greeting: greetingText,
        liveCount: 7,
      ),
    );
    expect(
      profile,
      isNot(
        const HomeProfile(
          name: displayName,
          avatarUrl: avatarUrl,
          greeting: greetingText,
          liveCount: 7,
        ),
      ),
    );
    expect(profile.props, hasLength(4));
  });
}
