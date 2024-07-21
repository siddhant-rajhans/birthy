import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_birthday_screen.dart';
import 'birthday_model.dart';
import 'notification_service.dart';

class BirthdayListScreen extends StatefulWidget {
  final List<Birthday> birthdays;
  final Function(Birthday) onBirthdayEdited;
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
          return ListTile(
            title: Text(birthday.name),
            subtitle: Text(DateFormat('y MMMM d').format(birthday.dateOfBirth)),
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
                          onBirthdayAdded: (updatedBirthday) => widget.onBirthdayEdited(updatedBirthday),
                          initialBirthday: birthday,
                        ),
                      ),
                    );
                    if (updatedBirthday != null) {
                      setState(() {
                        final birthdayIndex = widget.birthdays.indexOf(birthday);
                        widget.birthdays[birthdayIndex] = updatedBirthday;
                        widget.onBirthdayEdited(updatedBirthday); // Notify parent to update notification
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
                              setState(() {
                                widget.onBirthdayRemoved(birthday);
                              });
                              Navigator.pop(context);
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
          );
        },
      ),
    );
  }
}
