import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
              Colors.transparent,
              Colors.black,
            ],
            stops: [0.0, 0.2, 0.8, 1.0],
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
