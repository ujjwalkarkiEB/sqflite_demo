import '../../../model/user.dart';

abstract class DatabaseService {
  Future<void> addUser(User user);
  Future<void> deleteUser(User user);
  Future<void> updateUser(User user);
}
