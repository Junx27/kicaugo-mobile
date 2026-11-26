import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/presentation/bloc/home_event.dart';

void main() {
  test('HomeCategorySelected menyimpan nama kategori', () {
    const name = 'Kenari';
    const createEvent = HomeCategorySelected.new;

    expect(const HomeCategorySelected(name).name, name);
    expect(createEvent(name).name, name);
  });
}
