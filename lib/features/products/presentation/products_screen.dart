import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../products/domain/product.dart';
import '../../reports/report_screen.dart';
import '../../reports/report_utils.dart';

import 'package:restock_app/features/products/data/product_storage.dart';

import 'package:restock_app/features/products/data/excel_import_service.dart';

import 'package:restock_app/features/products/data/excel_template_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() =>
      _ProductsScreenState();
}

class _ProductsScreenState
    extends State<ProductsScreen> {
  List<Product> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {
    final loadedProducts =
        await ProductStorage.loadProducts();

    setState(() {
      products = loadedProducts;

      if (products.isEmpty) {
        products = [
          Product(
            id: '1',
            name: 'Coca Cola',
            supplier: 'Supplier A',
            safeStock: 10,
            currentStock: 4,
          ),
        ];
      }

      isLoading = false;
    });
  }

  Future<void> saveProducts() async {
    await ProductStorage.saveProducts(
      products,
    );
  }

  void openEditDialog(Product product, int index) {
    final nameController =
        TextEditingController(
      text: product.name,
    );

    final supplierController =
        TextEditingController(
      text: product.supplier,
    );

    final safeStockController =
        TextEditingController(
      text: product.safeStock.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(
                  labelText: 'Product Name',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    supplierController,
                decoration:
                    const InputDecoration(
                  labelText: 'Supplier',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    safeStockController,
                keyboardType:
                    TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                ],
                decoration:
                    const InputDecoration(
                  labelText: 'Safe Stock',
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () async {
                final confirmed =
                    await showDialog<bool>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title:
                          const Text('Delete Product'),
                      content: const Text(
                        'Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              false,
                            );
                          },
                          child:
                              const Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              true,
                            );
                          },
                          child:
                              const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  setState(() {
                    products.removeAt(index);
                  });

                  await saveProducts();

                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                final safeStock =
                    int.tryParse(
                          safeStockController
                              .text,
                        ) ??
                        0;

                setState(() {
                  products[index] = Product(
                    id: product.id,
                    name: nameController.text,
                    supplier:
                        supplierController.text,
                    safeStock: safeStock,
                    currentStock:
                        product.currentStock,
                  );
                });

                await saveProducts();

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void openAddProductDialog() {
    final nameController =
        TextEditingController();

    final supplierController =
        TextEditingController();

    final safeStockController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(
                  labelText: 'Product Name',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    supplierController,
                decoration:
                    const InputDecoration(
                  labelText: 'Supplier',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    safeStockController,
                keyboardType:
                    TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                ],
                decoration:
                    const InputDecoration(
                  labelText: 'Safe Stock',
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final safeStock =
                    int.tryParse(
                          safeStockController
                              .text,
                        ) ??
                        0;

                setState(() {
                  products.add(
                    Product(
                      id: DateTime.now()
                          .toString(),
                      name:
                          nameController.text,
                      supplier:
                          supplierController
                              .text,
                      safeStock:
                          safeStock,
                      currentStock: 0,
                    ),
                  );
                });

                await saveProducts();

                Navigator.pop(context);
              },
              child:
                  const Text('Add Product'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restock'),
      ),

      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,

        spacing: 12,
        spaceBetweenChildren: 12,

        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.add,
            ),
            label: 'Add Product',
            onTap: () {
              openAddProductDialog();
            },
          ),

          SpeedDialChild(
            child: const Icon(
              Icons.upload_file,
            ),
            label: 'Import Excel',
            onTap: () async {
              final importedProducts =
                  await ExcelImportService
                      .importProductsFromExcel();

              if (importedProducts
                  .isEmpty) {
                return;
              }

              setState(() {
                products.addAll(
                  importedProducts,
                );
              });

              await saveProducts();
            },
          ),

          SpeedDialChild(
            child: const Icon(
              Icons.download,
            ),
            label: 'Download Template',
            onTap: () async {
              await ExcelTemplateService
                  .generateTemplate();
            },
          ),

          SpeedDialChild(
            child: const Icon(
              Icons.picture_as_pdf,
            ),
            label: 'Generate Report',
            onTap: () {
              final report =
                  generateSupplierReport(
                products,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ReportScreen(
                    report: report,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Product',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      'Current Stock',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Text(
                      'Actions',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount:
                    products.length,

                separatorBuilder:
                    (_, __) =>
                        const SizedBox(
                  height: 10,
                ),

                itemBuilder:
                    (context, index) {
                  final product =
                      products[index];

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),

                    decoration:
                        BoxDecoration(
                      border: Border.all(
                        color: Colors
                            .grey
                            .shade300,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                product.name,

                                style:
                                    const TextStyle(
                                  fontSize: 18,

                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              Text(
                                product.supplier,

                                style:
                                    TextStyle(
                                  color: Colors
                                      .grey
                                      .shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 2,

                          child:
                              TextFormField(
                            initialValue:
                                product
                                    .currentStock
                                    .toString(),

                            keyboardType:
                                TextInputType
                                    .number,

                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly,
                            ],

                            onChanged:
                                (value) {
                              final stock =
                                  int.tryParse(
                                        value,
                                      ) ??
                                      0;

                              setState(() {
                                products[index] =
                                    Product(
                                  id: product.id,
                                  name:
                                      product.name,
                                  supplier:
                                      product
                                          .supplier,
                                  safeStock:
                                      product
                                          .safeStock,
                                  currentStock:
                                      stock,
                                );
                              });

                              saveProducts();
                            },

                            decoration:
                                const InputDecoration(
                              border:
                                  OutlineInputBorder(),
                              isDense:
                                  true,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,

                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  openEditDialog(
                                    product,
                                    index,
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}