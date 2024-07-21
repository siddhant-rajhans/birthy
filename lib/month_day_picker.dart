import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

class MonthDayPicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const MonthDayPicker({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<MonthDayPicker> createState() => _MonthDayPickerState();
}

class _MonthDayPickerState extends State<MonthDayPicker> {
  late int _selectedDay;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate.day;
    _selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Date:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        NumberPicker(
          value: _selectedDay,
          minValue: 1,
          maxValue: 31,
          onChanged: (value) {
            setState(() {
              _selectedDay = value;
              _updateSelectedDate();
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Month: ${DateFormat('MMMM').format(DateTime(2024, _selectedMonth))} ($_selectedMonth)',
          style: const TextStyle(fontSize: 16),
        ),
        NumberPicker(
          value: _selectedMonth,
          minValue: 1,
          maxValue: 12,
          onChanged: (value) {
            setState(() {
              _selectedMonth = value;
              _updateSelectedDate();
            });
          },
          itemWidth: 100,
        ),
      ],
    );
  }

  void _updateSelectedDate() {
    final now = DateTime.now();
    final maxDaysInMonth =
        DateTime(now.year, _selectedMonth + 1, 0).day; // Get last day of month
    if (_selectedDay > maxDaysInMonth) {
      _selectedDay = maxDaysInMonth;
    }
    widget.onDateSelected(
        DateTime(now.year, _selectedMonth, _selectedDay));
  }
}
