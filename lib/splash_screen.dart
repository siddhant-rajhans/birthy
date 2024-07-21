import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Center(
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
              stops: [0.0, 0.1, 0.9, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              'images/1.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
