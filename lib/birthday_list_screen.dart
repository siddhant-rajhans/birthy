import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'add_birthday_screen.dart';
import 'birthday_model.dart';

class BirthdayListScreen extends StatefulWidget {
  final Box<Birthday> birthdaysBox; // Add this line
  final Function(Birthday) onBirthdayRemoved;
  final Function(Birthday) onBirthdayAdded;

  const BirthdayListScreen({
    required this.birthdaysBox, // Update this line
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
    return MaterialApp( // Wrap the Scaffold with MaterialApp
      home: Scaffold(
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
                  widget.birthdaysBox.add(birthday);
                  setState(() {}); // This will rebuild the widget and display the new birthday
                },
                birthdaysBox: widget.birthdaysBox,
              ),
            ),
          );
          if (newBirthday != null) {
            // Handle scrolling to the new birthday if needed
          }
        },
        child: const Icon(Icons.cake), // Specify the icon here
        backgroundColor: Colors.pink[300], // Example: Change button color
      ),
      body: ListView.builder(
        itemCount: widget.birthdaysBox.values.length,
        itemBuilder: (context, index) {
          final birthday = widget.birthdaysBox.values.toList()[index];
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
                subtitle:
                    Text(DateFormat('MMMM d').format(birthday.dateOfBirth)),
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
                              birthdays:
                                  widget.birthdaysBox, // Pass birthdays here
                            ),
                          ),
                        );
                        if (updatedBirthday != null) {
                          await widget.birthdaysBox.put(updatedBirthday.key, updatedBirthday); // Update to use birthdaysBox
                          setState(() {
                            final birthdayIndex = widget.birthdaysBox.values.toList().indexOf(birthday);
                            widget.birthdaysBox.values.toList()[birthdayIndex] = updatedBirthday;
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
                            content: Text(
                                'Are you sure you want to remove ${birthday.name}\'s birthday?'),
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
                                    // widget.birthdays.remove(birthday);
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
    ));
  }
}
