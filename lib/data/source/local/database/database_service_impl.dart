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
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAllUsers() async {
    throw UnimplementedError();
  }

  @override
  Future<void> addUser(User user) async {
    try {
      final box = _databaseHelper.userBox;
      await box.add(user);
      await user.save();
    } catch (e) {
      print('insertion error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(User user) async {
    try {
      await user.delete();
    } catch (e) {
      print('deletion error: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await user.save();
    } catch (e) {
      print('update error: ${e.toString()}');
    }
  }
}
