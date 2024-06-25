import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  User({
    required this.name,
    required this.age,
  });

  @HiveField(1)
  late String name;
  @HiveField(2)
  late int age;
}
