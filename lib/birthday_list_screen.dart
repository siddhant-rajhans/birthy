import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_birthday_screen.dart';
import 'birthday_model.dart';

class BirthdayListScreen extends StatefulWidget {
  final List<Birthday> birthdays;
  final Function(Birthday, Birthday) onBirthdayEdited;
  final Function(Birthday) onBirthdayRemoved;

  const BirthdayListScreen({
    required this.birthdays,
    required this.onBirthdayEdited,
    required this.onBirthdayRemoved,
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

        title: const Text('Dates to remind'),
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
                          onBirthdayAdded: (updatedBirthday) => widget.onBirthdayEdited(birthday, updatedBirthday),
                          initialBirthday: birthday,
                          birthdays: widget.birthdays, // Pass birthdays here
                        ),
                      ),
                    );
                    if (updatedBirthday != null) {
                      setState(() {
                        final birthdayIndex = widget.birthdays.indexOf(birthday);
                        widget.birthdays[birthdayIndex] = updatedBirthday;
                        widget.onBirthdayEdited(birthday, updatedBirthday); // Notify parent to update notification
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
                              widget.onBirthdayRemoved(birthday);
                              Navigator.pop(context); // Close the dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Birthday removed'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
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
