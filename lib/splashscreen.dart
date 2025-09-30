import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fyp/reusable/colors_util.dart';
import 'package:fyp/reusable/reusable_widgets.dart';
import 'package:fyp/screens/login/signup/authpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: AnimatedSplashScreen(
        splash: logoWidget("asset/image/RecycleMate Logo.png"),
        splashIconSize: 160,
        splashTransition: SplashTransition.scaleTransition,
        animationDuration: const Duration(milliseconds: 1000),
        backgroundColor: hexStringToColor("9ADE7B"),
        nextScreen: const AuthPage(),
      ),
    ));
  }
}
