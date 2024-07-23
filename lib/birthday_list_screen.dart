import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'add_birthday_screen.dart';
import 'birthday_model.dart';

class BirthdayListScreen extends StatefulWidget {
  final Box<Birthday> birthdaysBox;
  final Function(Birthday) onBirthdayRemoved;
  final Function(Birthday) onBirthdayAdded;

  const BirthdayListScreen({
    required this.birthdaysBox,
    required this.onBirthdayRemoved,
    required this.onBirthdayAdded,
    Key? key,
  }) : super(key: key);

  @override
  State<BirthdayListScreen> createState() => _BirthdayListScreenState();
}

class _BirthdayListScreenState extends State<BirthdayListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dates to remind'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBirthdayScreen(
                onBirthdayAdded: (birthday) {
                  widget.onBirthdayAdded(birthday);
                },
              ),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.cake),
        backgroundColor: Colors.pink[300],
      ),
      body: ValueListenableBuilder<Box<Birthday>>(
        valueListenable: widget.birthdaysBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No birthdays yet.'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final birthday = box.getAt(index)!;
              return Dismissible(
                key: ValueKey(birthday.id),
                onDismissed: (direction) {
                  widget.onBirthdayRemoved(birthday);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${birthday.name}\'s birthday deleted'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      birthday.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                        DateFormat('MMMM d').format(birthday.dateOfBirth)),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBirthdayScreen(
                              onBirthdayAdded: (birthday) {
                                widget.birthdaysBox.put(birthday.key, birthday);
                              },
                              initialBirthday: birthday,
                            ),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
