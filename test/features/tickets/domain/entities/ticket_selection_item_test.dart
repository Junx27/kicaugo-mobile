import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/tickets/domain/entities/ticket_selection_item.dart';

void main() {
  const item = TicketSelectionItem(
    id: 9,
    name: 'Kacer Ring',
    session: 'Sesi 02',
    time: '09:15 WIB',
    price: 'Rp 150.000',
  );

  test('entitas tiket membandingkan seluruh field', () {
    const same = TicketSelectionItem(
      id: 9,
      name: 'Kacer Ring',
      session: 'Sesi 02',
      time: '09:15 WIB',
      price: 'Rp 150.000',
    );
    const other = TicketSelectionItem(
      id: 10,
      name: 'Kacer Ring',
      session: 'Sesi 02',
      time: '09:15 WIB',
      price: 'Rp 150.000',
    );

    expect(item, same);
    expect(item.hashCode, same.hashCode);
    expect(item, isNot(other));
  });
}
