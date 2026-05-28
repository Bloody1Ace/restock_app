import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../products/domain/product.dart';

class PdfService {
  static Future<void> generateReportPdf(
    Map<String, List<Product>> report,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Text(
              'Restock Report',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 24),

            ...report.entries.map((entry) {
              final supplier = entry.key;
              final products = entry.value;

              return pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    supplier,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 12),

                  ...products.map((product) {
                    return pw.Padding(
                      padding:
                          const pw.EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: pw.Row(
                        mainAxisAlignment:
                            pw.MainAxisAlignment
                                .spaceBetween,
                        children: [
                          pw.Text(product.name),

                          pw.Text(
                            'Order ${product.reorderQuantity}',
                          ),
                        ],
                      ),
                    );
                  }),

                  pw.SizedBox(height: 24),
                ],
              );
            }),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async =>
          pdf.save(),
    );
  }
}