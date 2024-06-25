import 'package:flutter_sqflite_demo/constants/db_constants.dart';
import 'package:flutter_sqflite_demo/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();
  static Database? _db;

  final String _tableName = DbConstants.tableName;
  final String _tableIDColumnName = DbConstants.tableIDColumnName;
  final String _tableUserNameColumnName = DbConstants.tableUserNameColumnName;
  final String _tableAgeColumnName = DbConstants.tableAgeColumnName;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final path = await getDatabasesPath();

    final dbPath = join(path, 'test.db');

    final database = await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE $_tableName  ('
          ' $_tableIDColumnName INTEGER PRIMARY KEY AUTOINCREMENT ,'
          '$_tableUserNameColumnName TEXT NOT NULL,'
          '$_tableAgeColumnName INTEGER NOT NULL)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<List<User>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users = await db.query(_tableName);
      return List.generate(
        users.length,
        (index) {
          return User(
              userId: users[index][_tableIDColumnName],
              name: users[index][_tableUserNameColumnName],
              age: users[index][_tableAgeColumnName]);
        },
      );
    } catch (e) {
      print('get all users error: ${e.toString()}');
      return [];
    }
  }

  Future<void> addUser(User user) async {
    final db = await database;
    try {
      final id = await db.insert(
          _tableName,
          {
            _tableIDColumnName: user.userId,
            _tableUserNameColumnName: user.name,
            _tableAgeColumnName: user.age
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
      user = user.copyWith(userId: id);
      print('Added user with id: ${user.userId}');
    } catch (e) {
      print('insertion error: ${e.toString()}');
    }
  }

  Future<void> deleteUser(int id) async {
    print('id: $id');
    final db = await database;
    try {
      await db.delete(
        _tableName,
        where: '$_tableIDColumnName = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('deletion error: ${e.toString()}');
    }
  }

  Future<void> updateUser(
      int userId, Map<String, dynamic> fieldToUpdate) async {
    final db = await database;
    try {
      await db.update(_tableName, fieldToUpdate,
          where: '$_tableIDColumnName = ?', whereArgs: [userId]);
    } catch (e) {
      print('update error: ${e.toString()}');
    }
  }
}
