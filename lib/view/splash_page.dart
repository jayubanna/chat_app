import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TweenAnimationBuilder(
        duration: const Duration(seconds: 3),
        onEnd: () {
          Get.offAndToNamed("/login_page");
        },
        tween: Tween(begin: 0.0, end: 130.0),
        builder: (context, value, child) {
          return Center(
            child: Image.asset(
              "assets/chat.png",
              height: value,
            ),
          );
        },
      ),
    );
  }
}
