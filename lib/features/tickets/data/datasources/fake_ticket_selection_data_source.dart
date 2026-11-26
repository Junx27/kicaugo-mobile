import '../../domain/entities/ticket_selection_item.dart';

/// Data contoh saat halaman pemesanan dibuka tanpa argumen.
abstract final class FakeTicketSelectionDataSource {
  static const TicketSelectionItem defaultItem = TicketSelectionItem(
    id: 1,
    name: 'Murai Batu Utama - Raja Batavia',
    session: 'Sesi 04',
    time: '10:30 WIB',
    price: 'Rp 500.000',
  );
}
