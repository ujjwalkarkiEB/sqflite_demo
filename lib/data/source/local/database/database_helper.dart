import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../model/user.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;

  Future<void> initializeDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>('users');
  }

  Box<User> get userBox => Hive.box<User>('users');
}
