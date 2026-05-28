import 'package:flutter/material.dart';

import '../products/domain/product.dart';

import 'pdf_service.dart';

class ReportScreen extends StatelessWidget {
  final Map<String, List<Product>> report;

  const ReportScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Restock Report'),

            actions: [
                IconButton(
                onPressed: () async {
                    await PdfService.generateReportPdf(
                    report,
                    );
                },
                icon: const Icon(Icons.picture_as_pdf),
                ),
            ],
        ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: report.entries.map((entry) {
          final supplier = entry.key;
          final products = entry.value;

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    supplier,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ...products.map((product) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Order ${product.reorderQuantity}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}