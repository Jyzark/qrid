import 'package:qrid/databases/scanned_history_database.dart';
import 'package:sqflite/sqflite.dart';

class ScannedHistoryController {
  ScannedHistoryDBManager database = ScannedHistoryDBManager.instance;
  Future<List<Map<String, dynamic>>> getHistory() async {
    Database db = await database.db;
    List<Map<String, dynamic>> historyList = await db.query(
      "scanned_history",
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
      "scanned_history",
      {
        "type": itemType,
        "title": itemTitle,
        "rawData": itemRawData,
      },
    );
  }
}
