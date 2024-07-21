import 'package:birthy/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'adapters.dart';
import 'add_birthday_screen.dart';
import 'birthday_list_screen.dart';
import 'birthday_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('birthdays');
  Hive.registerAdapter(BirthdayAdapter());
  await NotificationService.initialize();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    birthdaysBox = Hive.box<Birthday>('birthdays');
    _loadBirthdays();
  }

  late Box<Birthday> birthdaysBox;

  void addBirthday(Birthday birthday) async {
    await birthdaysBox.add(birthday); // Birthday object should have all required fields
    _scheduleNotification(birthday);
  }

  void _scheduleNotification(Birthday birthday) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      birthday.dateOfBirth.month,
      birthday.dateOfBirth.day,
      9,
      0,
      0,
    );

    // If birthday has already passed this year, schedule for next year
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 365));
    }

    await NotificationService.showNotification(
      id: birthday.id,
      title: 'Birthday Reminder',
      body: 'It\'s ${birthday.name}\'s birthday!',
      scheduledDate: scheduledDate,
    );
  }

  void editBirthday(Birthday oldBirthday, Birthday updatedBirthday) async {
    final index = birthdaysBox.values.toList().indexOf(oldBirthday);
    await birthdaysBox.putAt(index, updatedBirthday);
    await NotificationService.cancelNotification(id: updatedBirthday.id);
    _scheduleNotification(updatedBirthday);
  }

  void removeBirthday(Birthday birthday) async {
    await birthdaysBox.delete(birthday);
    await NotificationService.cancelNotification(id: birthday.id);
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
                birthdays: birthdaysBox.values.toList(), // Pass the birthdays list here
              ),
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
