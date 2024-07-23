import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:birthy/month_day_picker.dart';

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
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap Column with SingleChildScrollView
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
                    id: widget.initialBirthday?.id ?? DateTime.now().millisecondsSinceEpoch,
                  );
                  widget.onBirthdayAdded(birthday); 
                  Navigator.pop(context, birthday);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350), // Change button color
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

}
