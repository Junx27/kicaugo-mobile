import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/theme/app_tones.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/agenda.dart';
import 'package:rumahkicau_mobile/features/schedule/domain/entities/schedule_region.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/schedule_format.dart';
import 'package:rumahkicau_mobile/features/schedule/presentation/schedule_strings.dart';

void main() {
  test('format tanggal berbahasa Indonesia', () {
    final sunday = DateTime(2026, 11, 22);

    expect(weekdayName(sunday), 'Minggu');
    expect(weekdayShort(DateTime(2026, 11, 20)), 'Jum');
    expect(longDate(sunday), 'Minggu, 22 Nov 2026');
    expect(longDate(DateTime(2026, 12, 7)), 'Senin, 7 Des 2026');
  });

  test('label wilayah', () {
    expect(ScheduleRegion.all.label, ScheduleStrings.allRegions);
    expect(
      ScheduleRegion.values.map((region) => region.label).toSet(),
      hasLength(ScheduleRegion.values.length),
    );
  });

  test('aksen kartu dipetakan ke tone pastel', () {
    expect(AgendaAccent.periwinkle.tone, AppTones.periwinkle);
    expect(AgendaAccent.pink.tone, AppTones.pink);
    expect(AgendaAccent.lime.tone, AppTones.lime);
    expect(AgendaAccent.yellow.tone, AppTones.yellow);
  });

  test('setiap jenis lencana punya warna dan ikon berbeda', () {
    expect(AgendaBadgeKind.open.colors.background, AppColors.lime);
    expect(AgendaBadgeKind.almostFull.colors.foreground, AppColors.onPink);
    expect(AgendaBadgeKind.promo.colors.background, AppColors.lavender);
    expect(AgendaBadgeKind.info.colors.background, AppColors.surface);
    expect(
      AgendaBadgeKind.values.map((kind) => kind.icon).toSet(),
      hasLength(AgendaBadgeKind.values.length),
    );
  });
}
