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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'supplier': supplier,
      'safeStock': safeStock,
      'currentStock': currentStock,
    };
  }

  factory Product.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return Product(
      id: map['id'],
      name: map['name'],
      supplier: map['supplier'],
      safeStock: map['safeStock'],
      currentStock: map['currentStock'],
    );
  }
}