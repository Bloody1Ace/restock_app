import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../products/domain/product.dart';

class PdfService {
  static Future<void> generateReportPdf(
    Map<String, List<Product>> report,
  ) async {
    final font = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/NotoSans-Regular.ttf',
      ),
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Text(
              'Αναφορά Παραγγελίας',
              style: pw.TextStyle(
                font: font,
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 20),

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
                      font: font,
                      fontSize: 20,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 10),

                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              'Προϊόν',
                              style: pw.TextStyle(
                                font: font,
                                fontWeight:
                                    pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              'Ποσότητα',
                              style: pw.TextStyle(
                                font: font,
                                fontWeight:
                                    pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      ...products.map(
                        (product) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.all(6),
                              child: pw.Text(
                                product.name,
                                style: pw.TextStyle(
                                  font: font,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding:
                                  const pw.EdgeInsets.all(6),
                              child: pw.Text(
                                product.reorderQuantity
                                    .toString(),
                                style: pw.TextStyle(
                                  font: font,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),
                ],
              );
            }),
          ];
        },
      ),
    );

    final bytes = await pdf.save();

    await _savePdf(
      bytes,
      'Restock_Report.pdf',
    );
  }

  static Future<void> _savePdf(
    Uint8List bytes,
    String fileName,
  ) async {
    if (kIsWeb) {
      await Printing.sharePdf(
        bytes: bytes,
        filename: fileName,
      );
      return;
    }

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/$fileName',
    );

    await file.writeAsBytes(bytes);
  }
}