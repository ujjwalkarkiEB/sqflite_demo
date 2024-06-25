import 'package:sqflite/sqflite.dart';

import '../../../model/user.dart';

abstract class DatabaseService {
  Future<Database> get database;
  Future<List<User>> getAllUsers();
  Future<void> addUser(User user);
  Future<void> deleteUser(int userId);
  Future<void> updateUser(int userId, Map<String, dynamic> fieldsToUpdate);
}
