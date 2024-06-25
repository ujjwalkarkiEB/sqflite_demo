import 'package:flutter_sqflite_demo/data/source/local/database/database_service_impl.dart';

import '../model/user.dart';

class UserRepository {
  UserRepository._();
  static final UserRepository _instance = UserRepository._();
  static UserRepository get instance => _instance;

  final DatabaseServiceImpl _dbService = DatabaseServiceImpl.instance;

  Future<void> addUser(User user) async {
    await _dbService.addUser(user);
  }

  Future<void> deleteUser(User user) async {
    await _dbService.deleteUser(user);
  }

  Future<void> updateUser(User user, {String? name, int? age}) async {
    if (name != null) {
      user.name = name;
    }
    if (age != null) {
      user.age = age;
    }
    await _dbService.updateUser(user);
  }
}
