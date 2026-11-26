import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/event/domain/entities/featured_contest.dart';

void main() {
  test('FeaturedContest membandingkan seluruh field', () {
    const value = FeaturedContest(
      id: 1,
      title: 'Lomba Unggulan',
      schedule: 'Minggu, 6 Des • Jakarta',
      distance: '5 km',
      prize: 'Rp 10.000.000',
      slots: '4 Gantangan',
      attendees: (initials: <String>['BS'], others: 2),
      latitude: -6.2,
      longitude: 106.8,
    );
    const same = FeaturedContest(
      id: 1,
      title: 'Lomba Unggulan',
      schedule: 'Minggu, 6 Des • Jakarta',
      distance: '5 km',
      prize: 'Rp 10.000.000',
      slots: '4 Gantangan',
      attendees: (initials: <String>['BS'], others: 2),
      latitude: -6.2,
      longitude: 106.8,
    );
    const other = FeaturedContest(
      id: 2,
      title: 'Lomba Unggulan',
      schedule: 'Minggu, 6 Des • Jakarta',
      distance: '5 km',
      prize: 'Rp 10.000.000',
      slots: '4 Gantangan',
      attendees: (initials: <String>['BS'], others: 2),
      latitude: -6.2,
      longitude: 106.8,
    );

    expect(value, same);
    expect(value.hashCode, same.hashCode);
    expect(value, isNot(other));
  });
}
