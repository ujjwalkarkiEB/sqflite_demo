import 'package:flutter/material.dart';
import 'package:flutter_sqflite_demo/data/repository/user_repository.dart';
import 'package:flutter_sqflite_demo/utils/constants/db_constants.dart';
import 'package:flutter_sqflite_demo/data/model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userRepository = UserRepository.instance;

  Future<void> _showUpdateDialog(int userId) async {
    String? name;
    int? age;
    await showDialog(
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
                        onPressed: () async {
                          final Map<String, dynamic> fieldToUpdate = {};
                          if (name != null) {
                            fieldToUpdate[DbConstants.tableUserNameColumnName] =
                                name;
                          }

                          if (age != null) {
                            fieldToUpdate[DbConstants.tableAgeColumnName] = age;
                          }
                          await userRepository.updateUser(
                              userId, fieldToUpdate);
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text('Update')),
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
                    print('name: $name');
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    age = int.tryParse(value);
                    print('age: $age');
                  },
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    print('age: $age');
                    print('name: $name');
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<User>>(
                  future: userRepository.getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error in fetching data!'),
                      );
                    }

                    if (snapshot.hasData) {
                      final users = snapshot.data;
                      return users!.isEmpty
                          ? const Center(
                              child: Text('No users have been added yet!'),
                            )
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return Dismissible(
                                  key: ValueKey(users[index].userId),
                                  child: ListTile(
                                    title: Text(user.name),
                                    subtitle: Text('Age: ${user.age}'),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          await _showUpdateDialog(user.userId!);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.edit_square)),
                                  ),
                                  onDismissed: (direction) async {
                                    await userRepository
                                        .deleteUser(user.userId!);

                                    setState(() {});
                                  },
                                );
                              },
                            );
                    }
                    return const Center(
                      child: Text('Something went wrong!'),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddItemModal();
          setState(() {});
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
