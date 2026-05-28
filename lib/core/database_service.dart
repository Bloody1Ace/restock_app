import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  static Future<void> init() async {
    await Hive.initFlutter();
  }
}