import '../products/domain/product.dart';

Map<String, List<Product>> generateSupplierReport(
  List<Product> products,
) {
  final Map<String, List<Product>> report = {};

  for (final product in products) {
    if (product.reorderQuantity <= 0) {
      continue;
    }

    if (!report.containsKey(product.supplier)) {
      report[product.supplier] = [];
    }

    report[product.supplier]!.add(product);
  }

  return report;
}