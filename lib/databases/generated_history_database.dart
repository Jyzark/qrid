import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class GeneratedHistoryDBManager {
  GeneratedHistoryDBManager._private();
  static GeneratedHistoryDBManager instance =
      GeneratedHistoryDBManager._private();
  Database? _db;

  Future<Database> get db async {
    _db ??= await _initDB();
    return _db!;
  }

  Future _initDB() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, "generated_history.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        return await database.execute('''
            CREATE TABLE generated_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              type TEXT NOT NULL,
              title TEXT NOT NULL,
              rawData TEXT NOT NULL
            )
          ''');
      },
    );
  }

  Future closeDB() async {
    _db = await instance.db;
    _db!.close();
  }
}
