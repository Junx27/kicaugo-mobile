import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/features/home/domain/entities/bird_category_item.dart';

const String itemName = 'Murai Batu';
const String itemSlug = 'murai_batu';
const String itemIcon = 'assets/bird_categories/murai_batu.svg';

void main() {
  test('BirdCategoryItem menyimpan empat field dari payload API', () {
    const item = BirdCategoryItem(
      id: 1,
      name: itemName,
      slug: itemSlug,
      icon: itemIcon,
    );

    expect(item.id, 1);
    expect(item.name, itemName);
    expect(item.slug, itemSlug);
    expect(item.icon, itemIcon);
  });

  test('BirdCategoryItem memakai semua field dalam equality', () {
    const item = BirdCategoryItem(
      id: 1,
      name: itemName,
      slug: itemSlug,
      icon: itemIcon,
    );

    expect(
      item,
      const BirdCategoryItem(
        id: 1,
        name: itemName,
        slug: itemSlug,
        icon: itemIcon,
      ),
    );
    expect(
      item,
      isNot(
        const BirdCategoryItem(
          id: 2,
          name: itemName,
          slug: itemSlug,
          icon: itemIcon,
        ),
      ),
    );
    expect(item.props, hasLength(4));
  });
}
