import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../utils/constants/db_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;

  DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'test.db');

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE ${DbConstants.tableName} ('
          ' ${DbConstants.tableIDColumnName} INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' ${DbConstants.tableUserNameColumnName} TEXT NOT NULL,'
          ' ${DbConstants.tableAgeColumnName} INTEGER NOT NULL)',
        );
      },
      version: 1,
    );
  }
}
