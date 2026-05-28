import 'package:hive_flutter/hive_flutter.dart';

import '../domain/product.dart';

class ProductStorage {
  static const String boxName = 'products_box';

  static Future<void> saveProducts(
    List<Product> products,
  ) async {
    final box =
        await Hive.openBox(boxName);

    final data = products
        .map((product) => product.toMap())
        .toList();

    await box.put('products', data);
  }

  static Future<List<Product>>
      loadProducts() async {
    final box =
        await Hive.openBox(boxName);

    final data =
        box.get('products', defaultValue: []);

    return (data as List)
        .map(
          (item) => Product.fromMap(item),
        )
        .toList();
  }
}