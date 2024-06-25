import 'package:flutter_sqflite_demo/data/source/local/database/database_service_impl.dart';

import '../model/user.dart';

class UserRepository {
  UserRepository._();
  static final UserRepository _instance = UserRepository._();
  static UserRepository get instance => _instance;

  final DatabaseServiceImpl _dbService = DatabaseServiceImpl.instance;

  Future<List<User>> getAllUsers() async {
    try {
      return await _dbService.getAllUsers();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<void> addUser(User user) async {
    await _dbService.addUser(user);
  }

  Future<void> deleteUser(int userId) async {
    await _dbService.deleteUser(userId);
  }

  Future<void> updateUser(
      int userId, Map<String, dynamic> fieldsToUpdate) async {
    await _dbService.updateUser(userId, fieldsToUpdate);
  }
}
