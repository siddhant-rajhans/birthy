import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'adapters.dart';
import 'add_birthday_screen.dart';
import 'birthday_list_screen.dart';
import 'birthday_model.dart';
import 'notification_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('birthdays'); // Initialize Hive with box name
  Hive.registerAdapter(BirthdayAdapter()); // Register Birthday adapter
  await NotificationService.initialize(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box<Birthday> birthdaysBox = Hive.box<Birthday>('birthdays'); // Get birthdays box

  @override
  void initState() {
    super.initState();
    _loadBirthdays();
  }

  void _loadBirthdays() async {
    final birthdays = birthdaysBox.values.toList(); // Get all birthdays from box
    setState(() {
      _birthdays = birthdays;
    });
  }

  List<Birthday> _birthdays = [];

  void addBirthday(Birthday birthday) async {
    await birthdaysBox.add(birthday); // Birthday object should have all required fields
    _scheduleNotification(birthday);
    _loadBirthdays(); // Update UI after adding
  }

  void _scheduleNotification(Birthday birthday) async {
    final now = tz.TZDateTime.now(tz.local);
    final birthdayDate = tz.TZDateTime(
        tz.local,
        now.year,
        birthday.dateOfBirth.month,
        birthday.dateOfBirth.day,
        9,
        0,
        0);
    if (birthdayDate.isBefore(now)) {
      final nextYearBirthday =
      birthdayDate.add(const Duration(days: 365));
      await NotificationService.showNotification(
        id: birthday.id,
        title: 'Birthday Reminder',
        body: 'It\'s ${birthday.name}\'s birthday!',
        scheduledDate: nextYearBirthday,
      );
    } else {
      await NotificationService.showNotification(
        id: birthday.id,
        title: 'Birthday Reminder',
        body: 'It\'s ${birthday.name}\'s birthday!',
        scheduledDate: birthdayDate,
      );
    }
  }

  void editBirthday(int index, Birthday updatedBirthday) async {
    await birthdaysBox.putAt(index, updatedBirthday);
    await NotificationService.cancelNotification(id: updatedBirthday.id);
    _scheduleNotification(updatedBirthday);
    _loadBirthdays();
  }

  void removeBirthday(int index, Birthday birthday) async {
    await birthdaysBox.deleteAt(index);
    await NotificationService.cancelNotification(id: birthday.id);
    _loadBirthdays();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Birthdays'),
        ),
        body: ValueListenableBuilder<Box<Birthday>>(
          valueListenable: birthdaysBox.listenable(),
          builder: (context, box, _) {
            if (box.values.isEmpty) {
              return const Center(child: Text('No birthdays added yet!'));
            }
            return BirthdayListScreen(
              birthdays: box.values.toList(),
              onBirthdayEdited: editBirthday,
              onBirthdayRemoved: removeBirthday,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBirthdayScreen(
                onBirthdayAdded: addBirthday,
              ),
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
