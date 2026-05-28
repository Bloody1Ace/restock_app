import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../domain/product.dart';

class ExcelImportService {
  static Future<List<Product>>
      importProductsFromExcel() async {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result == null) {
      return [];
    }

    final file = File(
      result.files.single.path!,
    );

    final bytes =
        file.readAsBytesSync();

    final excel =
        Excel.decodeBytes(bytes);

    final List<Product> products = [];

    for (final sheet in excel.tables.keys) {
      final rows =
          excel.tables[sheet]!.rows;

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];

        final name =
            row[0]?.value.toString() ?? '';

        final supplier =
            row[1]?.value.toString() ?? '';

        final safeStock = int.tryParse(
              row[2]?.value.toString() ?? '0',
            ) ??
            0;

        products.add(
          Product(
            id: DateTime.now()
                .millisecondsSinceEpoch
                .toString() +
                i.toString(),

            name: name,
            supplier: supplier,
            safeStock: safeStock,
            currentStock: 0,
          ),
        );
      }
    }

    return products;
  }
}