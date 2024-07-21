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
    final birthdayDate = DateTime(DateTime.now().year, birthday.dateOfBirth.month, birthday.dateOfBirth.day);
    if (birthdayDate.isBefore(DateTime.now())) {
      birthdayDate = birthdayDate.add(const Duration(days: 365));
    }

    await NotificationService.showNotification(
      flutterLocalNotificationsPlugin,
      id: birthday.id, // Assuming 'id' is unique
      title: 'Birthday Reminder',
      body: 'It\'s ${birthday.name}\'s birthday!',
      scheduledDate: birthdayDate,
    );
  }

  void editBirthday(Birthday updatedBirthday) async {
    for (int i = 0; i < _birthdays.length; i++) {
      if (_birthdays[i] == updatedBirthday) {
        await birthdaysBox.putAt(i, updatedBirthday);
        await NotificationService.cancelNotification(flutterLocalNotificationsPlugin, id: _birthdays[i].id);
        _scheduleNotification(updatedBirthday);
        break;
      }
    }
    _loadBirthdays(); // Update UI after editing
  }

  void removeBirthday(Birthday birthday) async {
    // Assuming you have a way to access the key for deletion (e.g., using a unique ID field)
    await birthdaysBox.delete(birthday.key); // Use the correct key access method
    _loadBirthdays(); // Update UI after deleting
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
          builder: (context, box, widget) {
            if (box.values.isEmpty) {
              return const Center(child: Text('No birthdays added yet!'));
            }
            return BirthdayListScreen(
              birthdays: box.values.toList(), // Get birthdays from box
              onBirthdayEdited: editBirthday,
              onBirthdayRemoved: removeBirthday,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBirthdayScreen(onBirthdayAdded: addBirthday))),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
