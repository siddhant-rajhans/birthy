import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.red,
                Colors.orange,
                Colors.yellow,
              ],
              stops: [0.0, 0.4, 0.6, 1.0],
            ),
          ),
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
              stops: [0.0, 0.2, 0.8, 1.0], // Adjusted for stronger fade
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: Image.asset('images/1.png'),
          ),
        ),
      ),
    );
  }
}
