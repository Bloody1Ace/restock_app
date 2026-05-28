class Product {
  final String id;
  final String name;
  final String supplier;
  final int safeStock;
  final int currentStock;

  Product({
    required this.id,
    required this.name,
    required this.supplier,
    required this.safeStock,
    required this.currentStock,
  });

  int get reorderQuantity {
    if (currentStock >= safeStock) {
      return 0;
    }

    return safeStock - currentStock;
  }
}