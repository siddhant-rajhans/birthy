import 'package:flutter/material.dart';

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
  late int _selectedMonth;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<int>(
          value: _selectedMonth,
          onChanged: (newValue) {
            setState(() {
              _selectedMonth = newValue!;
              _selectedDay = _getValidDay(_selectedMonth, _selectedDay);
            });
          },
          items: List.generate(12, (index) {
            final month = index + 1;
            return DropdownMenuItem(
              value: month,
              child: Text(month.toString()),
            );
          }),
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: _selectedDay,
          onChanged: (newValue) {
            setState(() {
              _selectedDay = newValue!;
            });
          },
          items: List.generate(_getDaysInMonth(_selectedMonth), (index) {
            final day = index + 1;
            return DropdownMenuItem(
              value: day,
              child: Text(day.toString()),
            );
          }),
        ),
      ],
    );
  }

  int _getDaysInMonth(int month) {
    if (month == 2) {
      return 28; // Assuming non-leap year for simplicity
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }

  int _getValidDay(int month, int day) {
    final daysInMonth = _getDaysInMonth(month);
    if (day > daysInMonth) {
      return daysInMonth;
    }
    return day;
  }
}
