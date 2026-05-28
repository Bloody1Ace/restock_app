import 'dart:io';

import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ExcelTemplateService {
  static Future<void> generateTemplate() async {
    final excel = Excel.createExcel();

    final Sheet sheet =
        excel['Products'];

    sheet.appendRow([
      TextCellValue('Product'),
      TextCellValue('Supplier'),
      TextCellValue('SafeStock'),
    ]);

    sheet.appendRow([
      TextCellValue('Coca Cola'),
      TextCellValue('Supplier A'),
      IntCellValue(10),
    ]);

    final directory =
        await getApplicationDocumentsDirectory();

    final path =
        '${directory.path}/restock_template.xlsx';

    final file = File(path);

    final bytes = excel.encode();

    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }

    await OpenFilex.open(path);
  }
}