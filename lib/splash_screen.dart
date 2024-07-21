import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: FadeInImage(
          placeholder: const MemoryImage(Uint8List(0)), // Placeholder
          image: const AssetImage('assets/images/logo.png'),
          fit: BoxFit.contain,
          fadeOutDuration: const Duration(milliseconds: 500), // Adjust as needed
        ),
      ),
    );
  }
}
