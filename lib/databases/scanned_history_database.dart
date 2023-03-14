import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class DatabaseManager {
  // private constructor
  DatabaseManager._private();
  static DatabaseManager instance = DatabaseManager._private();
  Database? _db;
  // database getter
  Future<Database> get db async {
    _db ??= await _initDB();
    return _db!;
  }
  Future _initDB() async {
    // di _initDB kita buat table database SQL
    Directory documentDir = await getApplicationDocumentsDirectory();
    //join(path direktori dari dokumen aplikasi kita, nama dari database yang akan dibuat)
    String path = join(documentDir.path, "scanned_history.db");
    //version: 1 atau pertama karena baru dibuat/inisialisasi
    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        return await database.execute('''
            CREATE TABLE scanned_history (
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
  }}