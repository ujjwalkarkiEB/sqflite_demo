import 'package:flutter/material.dart';
import 'package:flutter_sqflite_demo/data/repository/user_repository.dart';
import 'package:flutter_sqflite_demo/data/source/local/database/database_helper.dart';
import 'package:flutter_sqflite_demo/data/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userRepository = UserRepository.instance;

  Future<void> _showUpdateDialog(User user) async {
    String? name;
    int? age;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    age = int.tryParse(value);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          userRepository.updateUser(user, name: name, age: age);

                          Navigator.of(context).pop();
                        },
                        child: const Text('Update')),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddItemModal() async {
    String? name;
    int? age;
    await showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.purple.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    age = int.tryParse(value);
                  },
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    if (name != null && age != null) {
                      await userRepository
                          .addUser(User(name: name!, age: age!));
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ValueListenableBuilder<Box<User>>(
                    valueListenable:
                        DatabaseHelper.instance.userBox.listenable(),
                    builder: (context, box, _) {
                      final users = box.values.toList().cast<User>();
                      return users.isEmpty
                          ? const Center(
                              child: Text('No users have been added yet!'),
                            )
                          : ListView.separated(
                              itemCount: box.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return Dismissible(
                                  key: ValueKey(user),
                                  child: ListTile(
                                    tileColor: Colors.grey.withOpacity(0.3),
                                    title: Text(user.name.toUpperCase()),
                                    subtitle: Text('Age: ${user.age}'),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          await _showUpdateDialog(user);
                                        },
                                        icon: const Icon(Icons.edit_square)),
                                  ),
                                  onDismissed: (direction) async {
                                    await userRepository.deleteUser(user);
                                  },
                                );
                              },
                            );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddItemModal();
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
