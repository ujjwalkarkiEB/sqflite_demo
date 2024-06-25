import 'package:flutter_sqflite_demo/utils/constants/db_constants.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/user.dart';
import 'database_helper.dart';
import 'database_service.dart';

class DatabaseServiceImpl implements DatabaseService {
  // make this class singleton
  DatabaseServiceImpl._();
  static final DatabaseServiceImpl _instance = DatabaseServiceImpl._();
  static DatabaseServiceImpl get instance => _instance;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Database> get database async {
    return await _databaseHelper.database;
  }

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> users =
          await db.query(DbConstants.tableName);
      return List.generate(
        users.length,
        (index) {
          return User(
            userId: users[index][DbConstants.tableIDColumnName],
            name: users[index][DbConstants.tableUserNameColumnName],
            age: users[index][DbConstants.tableAgeColumnName],
          );
        },
      );
    } catch (e) {
      print('get all users error: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<void> addUser(User user) async {
    final db = await database;
    try {
      final id = await db.insert(
        DbConstants.tableName,
        {
          DbConstants.tableIDColumnName: user.userId,
          DbConstants.tableUserNameColumnName: user.name,
          DbConstants.tableAgeColumnName: user.age,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Added user with id: $id');
    } catch (e) {
      print('insertion error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    final db = await database;
    try {
      await db.delete(
        DbConstants.tableName,
        where: '${DbConstants.tableIDColumnName} = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('deletion error: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(
      int userId, Map<String, dynamic> fieldsToUpdate) async {
    final db = await database;
    try {
      await db.update(
        DbConstants.tableName,
        fieldsToUpdate,
        where: '${DbConstants.tableIDColumnName} = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('update error: ${e.toString()}');
    }
  }
}
