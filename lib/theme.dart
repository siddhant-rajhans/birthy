import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a custom text style for the app bar title
const TextStyle appBarTextStyle = TextStyle(
  fontFamily: 'Lobster', // Use the font family name directly
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// Create a ThemeData with the custom icon theme
ThemeData appTheme = ThemeData(
  primarySwatch: Colors.deepOrange,
  textTheme: GoogleFonts.nunitoTextTheme(),
  appBarTheme: const AppBarTheme(
    titleTextStyle: appBarTextStyle,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);
