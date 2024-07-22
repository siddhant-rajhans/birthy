import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:birthy/month_day_picker.dart';

import 'birthday_model.dart';

class AddBirthdayScreen extends StatefulWidget {
  final Function(Birthday) onBirthdayAdded;
  final Birthday? initialBirthday; // Can be null for new birthdays

  final List<Birthday> birthdays; // Add this line

  const AddBirthdayScreen(
      {Key? key, required this.onBirthdayAdded, this.initialBirthday, required this.birthdays}) // Add birthdays to the constructor
      : super(key: key);

  @override
  State<AddBirthdayScreen> createState() => _AddBirthdayScreenState();
}

class _AddBirthdayScreenState extends State<AddBirthdayScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialBirthday != null) {
      _nameController.text = widget.initialBirthday!.name;
      _selectedDate = widget.initialBirthday!.dateOfBirth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Birthday'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            MonthDayPicker(
              initialDate: _selectedDate ?? DateTime.now(),
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _selectedDate != null) {
                  final birthday = Birthday(
                    name: _nameController.text,
                    dateOfBirth: DateTime(DateTime.now().year, _selectedDate!.month, _selectedDate!.day),
                    id: widget.initialBirthday?.id ??
                        generateUniqueId(widget.birthdays), // Pass birthdays to the function
                  );
                  widget.onBirthdayAdded(birthday);
                  Navigator.pop(context, birthday);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300], // Change button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text(
                'Save Birthday',
                style: TextStyle(color: Colors.white), // Change text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  int generateUniqueId(List<Birthday> birthdays) {
    final existingIds = birthdays.map((birthday) => birthday.id).toSet();
    var uuid = const Uuid();
    int newId = uuid.v4().hashCode;
    while (existingIds.contains(newId)) {
      newId = uuid.v4().hashCode;
    }
    return newId;
  }
}
