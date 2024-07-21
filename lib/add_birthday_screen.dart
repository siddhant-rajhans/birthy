import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
              child: Text(
                  _selectedDate?.toString().split(' ').first ?? 'Select Date'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _selectedDate != null) {
                  final birthday = Birthday(
                    name: _nameController.text,
                    dateOfBirth: DateTime(DateTime.now().year,
                        _selectedDate!.month, _selectedDate!.day),
                    id: widget.initialBirthday?.id ?? generateUniqueId(widget.birthdays), // Pass birthdays to the function
                  );
                  widget.onBirthdayAdded(birthday);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Birthday'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100, 1, 1), // Allow past dates
      lastDate: DateTime(DateTime.now().year + 100, 12, 31), // Allow future dates
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate!.year,
          picked.month,
          picked.day,
        );
      });
    }
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
