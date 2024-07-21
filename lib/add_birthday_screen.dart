import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'birthday_model.dart';

class AddBirthdayScreen extends StatefulWidget {
  final Function(Birthday) onBirthdayAdded;
  final Birthday? initialBirthday; // Can be null for new birthdays

  const AddBirthdayScreen({Key? key, required this.onBirthdayAdded, this.initialBirthday}) : super(key: key);

  @override
  State<AddBirthdayScreen> createState() => _AddBirthdayScreenState();
}


class _AddBirthdayScreenState extends State<AddBirthdayScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  int? _id; // Initialize id to null

  // Function to generate unique ID (implementation based on your preference)
  int generateUniqueId() {
    // Replace this with your preferred logic for generating unique IDs (e.g., timestamps, random numbers)
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Birthday'),
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
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(_selectedDate?.toString().split(' ').first ?? 'Select Date'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _selectedDate != null) {
                  _id ??= generateUniqueId(); // Generate ID if not already set
                  final birthday = Birthday(
                    name: _nameController.text,
                    dateOfBirth: DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day),
                    id: _id!,
                  );
                  widget.onBirthdayAdded(birthday);
                  Navigator.pop(context); // Access context from Stateful Widget
                }
              },
              child: const Text('Add Birthday'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }
}
