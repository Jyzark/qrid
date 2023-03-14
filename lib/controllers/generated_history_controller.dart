import 'package:qrid/databases/generated_history_database.dart';
import 'package:sqflite/sqflite.dart';
class GeneratedHistoryController {
  DatabaseManager database = DatabaseManager.instance;
  Future<List<Map<String, dynamic>>> getHistory() async {
    Database db = await database.db;
    List<Map<String, dynamic>> historyList = await db.query(
      "generated_history",
      orderBy: "id DESC",
    );
    return historyList;
  }
  Future<void> addHistory({
    required String itemType,
    required String itemTitle,
    required String itemRawData,
  }) async {
    Database db = await database.db;
    await db.insert(
      "generated_history",
      {
        "type": itemType,
        "title": itemTitle,
        "rawData": itemRawData,
      },
    );
  }
}