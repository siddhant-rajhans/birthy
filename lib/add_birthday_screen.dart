import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'birthday_model.dart';

class AddBirthdayScreen extends StatefulWidget {
  final Function(Birthday) onBirthdayAdded;
  final Birthday? initialBirthday; // Can be null for new birthdays

  const AddBirthdayScreen(
      {Key? key, required this.onBirthdayAdded, this.initialBirthday})
      : super(key: key);

  @override
  State<AddBirthdayScreen> createState() => _AddBirthdayScreenState();
}

class _AddBirthdayScreenState extends State<AddBirthdayScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  int? _id; // Initialize id to null

  @override
  void initState() {
    super.initState();
    if (widget.initialBirthday != null) {
      _nameController.text = widget.initialBirthday!.name;
      _selectedDate = widget.initialBirthday!.dateOfBirth;
      _id = widget.initialBirthday!.id;
    }
  }

  int generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4().hashCode;
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
                    dateOfBirth: DateTime(_selectedDate!.year,
                        _selectedDate!.month, _selectedDate!.day),
                    id: _id ?? generateUniqueId(),
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
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
