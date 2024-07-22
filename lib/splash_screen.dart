import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _cacheImage();
  }

  Future<void> _cacheImage() async {
    final imageProvider = AssetImage('images/3.png');
    await precacheImage(imageProvider, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Image.asset('images/3.png'), // Display the image
      ),
    );
  }
}
