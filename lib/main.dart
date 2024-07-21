import 'package:birthy/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:birthy/theme.dart';
import 'package:birthy/splash_screen.dart';
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
  final birthdaysBox = await Hive.openBox<Birthday>('birthdays');
  runApp(MyApp(birthdaysBox: birthdaysBox));
}

class MyApp extends StatefulWidget {
  final Box<Birthday> birthdaysBox;
  const MyApp({Key? key, required this.birthdaysBox}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplashScreen = true;

  @override
  void initState() {
    super.initState();
    _checkLastOpened();
  }

  Future<void> _checkLastOpened() async {
    // Implement logic to check when the app was last opened
    // For simplicity, we'll just wait 2 seconds and then show the main app
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _showSplashScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: _showSplashScreen
          ? const SplashScreen()
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  'Birthdays',
                  style: appBarTextStyle,
                ),
              ),
              body: Builder(
                // Wrap with Builder
                builder: (context) => ValueListenableBuilder<Box<Birthday>>(
                  valueListenable: widget.birthdaysBox.listenable(),
                  builder: (context, box, _) {
                    if (box.values.isEmpty) {
                      return const Center(
                          child: Text('No birthdays added yet!'));
                    }
                    return BirthdayListScreen(
                      birthdays: box.values.toList(),
                      onBirthdayEdited: editBirthday,
                      onBirthdayRemoved: removeBirthday,
                    );
                  },
                ),
              ),
              floatingActionButton: Builder(
                // Wrap with Builder
                builder: (context) => FloatingActionButton(
                  onPressed: () => Navigator.push(
                    context, // Use context from Builder
                    MaterialPageRoute(
                      builder: (context) => AddBirthdayScreen(
                        onBirthdayAdded: addBirthday,
                        birthdays: widget.birthdaysBox.values
                            .toList(), // Pass the birthdays list here
                      ),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ),
            ),
    );
  }

  void addBirthday(Birthday birthday) async {
    try {
      await widget.birthdaysBox.add(birthday);
      _scheduleNotification(birthday);
    } catch (e) {
      // Handle error, e.g., show error message
      print('Error adding birthday: $e');
    }
  }

  void _scheduleNotification(Birthday birthday) async {
    // Consider allowing user to configure notification time
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
    // You might want to adjust this logic based on user preferences
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 365));
    }

    try {
      await NotificationService.showNotification(
        id: birthday.id,
        title: 'Birthday Reminder',
        body: 'It\'s ${birthday.name}\'s birthday!',
        scheduledDate: scheduledDate,
      );
    } catch (e) {
      // Handle error, e.g., show error message
      print('Error scheduling notification: $e');
    }
  }

  void editBirthday(Birthday oldBirthday, Birthday updatedBirthday) async {
    try {
      final index = widget.birthdaysBox.values.toList().indexOf(oldBirthday);
      await widget.birthdaysBox.putAt(index, updatedBirthday);
      await NotificationService.cancelNotification(id: updatedBirthday.id);
      _scheduleNotification(updatedBirthday);
    } catch (e) {
      // Handle error, e.g., show error message
      print('Error editing birthday: $e');
    }
  }

  void removeBirthday(Birthday birthday) async {
    try {
      await widget.birthdaysBox.delete(birthday);
      await NotificationService.cancelNotification(id: birthday.id);
    } catch (e) {
      // Handle error, e.g., show error message
      print('Error removing birthday: $e');
    }
  }
}
