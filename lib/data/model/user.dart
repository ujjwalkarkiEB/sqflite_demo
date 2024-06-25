class User {
  final int? userId;
  final String name;
  final int age;

  User({required this.name, required this.age, this.userId});

  User copyWith({int? userId, String? name, int? age}) {
    return User(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}
