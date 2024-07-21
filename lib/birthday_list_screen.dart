import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'add_birthday_screen.dart';
import 'birthday_model.dart';

class BirthdayListScreen extends StatefulWidget {
  final List<Birthday> birthdays;
  final Function(Birthday, Birthday) onBirthdayEdited;
  final Function(Birthday) onBirthdayRemoved;
  final Function(Birthday) onBirthdayAdded;

  const BirthdayListScreen({
    required this.birthdays,
    required this.onBirthdayEdited,
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
          final newBirthday = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBirthdayScreen(
                onBirthdayAdded: (birthday) {
                  setState(() {
                    widget.birthdays.add(birthday);
                  });
                  // Call the callback to update the list in main.dart
                  widget.onBirthdayAdded(birthday);
                },
                birthdays: widget.birthdays,
              ),
            ),
          );
          if (newBirthday != null) {
            // Handle scrolling to the new birthday if needed
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: widget.birthdays.length, 
        itemBuilder: (context, index) {
          final birthday = widget.birthdays[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(
                birthday.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(DateFormat('MMMM d').format(birthday.dateOfBirth)),
              trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    // Navigate to edit screen and update birthday on return
                    final updatedBirthday = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBirthdayScreen(
                          onBirthdayAdded: (birthday) {},
                          initialBirthday: birthday,
                          birthdays: widget.birthdays, // Pass birthdays here
                        ),
                      ),
                    );
                    if (updatedBirthday != null) {
                      final box = Hive.box<Birthday>('birthdays');
                      await box.put(updatedBirthday.key, updatedBirthday);
                      widget.onBirthdayEdited(birthday, updatedBirthday);
                      setState(() {
                        final birthdayIndex = widget.birthdays.indexOf(birthday);
                        widget.birthdays[birthdayIndex] = updatedBirthday;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: Text('Are you sure you want to remove ${birthday.name}\'s birthday?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final box = Hive.box<Birthday>('birthdays');
                              box.delete(birthday.key); // Delete from Hive
                              widget.onBirthdayRemoved(birthday);
                              Navigator.pop(context); // Close the dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Birthday deleted'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              setState(() {
                                widget.birthdays.remove(birthday);
                              });
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
