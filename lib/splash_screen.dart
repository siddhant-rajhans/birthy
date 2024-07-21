import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.red,
              Colors.orange,
              Colors.yellow,
            ],
            stops: [0.0, 0.4, 0.6, 1.0], // Adjusted stops for stronger fade
          ).createShader(bounds),
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            'images/1.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
