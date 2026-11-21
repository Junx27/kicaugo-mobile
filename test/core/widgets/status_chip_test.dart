import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/entities/ticket_status.dart';
import 'package:rumahkicau_mobile/core/theme/app_tones.dart';
import 'package:rumahkicau_mobile/core/widgets/status_chip.dart';

void main() {
  test('setiap status punya label dan tone sesuai aturan warna', () {
    expect(StatusChip.lookOf(TicketStatus.available).tone, AppTones.lime);
    expect(StatusChip.lookOf(TicketStatus.almostGone).tone, AppTones.yellow);
    expect(StatusChip.lookOf(TicketStatus.soldOut).tone, AppTones.pink);
    expect(StatusChip.lookOf(TicketStatus.waiting).tone, AppTones.periwinkle);
  });

  testWidgets('menampilkan label tiap status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              for (final status in TicketStatus.values)
                StatusChip(status: status),
            ],
          ),
        ),
      ),
    );

    for (final label in ['Tersedia', 'Segera Habis', 'Habis', 'Menunggu']) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
