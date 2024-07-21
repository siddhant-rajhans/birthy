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
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('birthdays');
  Hive.registerAdapter(BirthdayAdapter());
  await NotificationService.initialize();
  tz.initializeTimeZones();
  final birthdaysBox = await Hive.openBox<Birthday>('birthdays');
  runApp(MyApp(birthdaysBox: birthdaysBox));
}

class MyApp extends StatelessWidget {
  final Box<Birthday> birthdaysBox;
  const MyApp({Key? key, required this.birthdaysBox}) : super(key: key);

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
      home:  SplashScreen(),
    );
  }

}
