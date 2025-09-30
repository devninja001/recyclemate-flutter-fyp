// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fyp/reusable/dependencyinjection.dart';
import 'package:fyp/reusable/reusable_widgets.dart';
import 'package:fyp/screens/settings.dart';
import 'package:fyp/splashscreen.dart';
import 'package:get/get.dart';

List<CameraDescription> cameras = [];

Future main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  cameras = await availableCameras();
  HideStatusBar();

  runApp(const MyApp());

  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      cacheKey: keydarkmode,
      defaultValue: false,
      builder: (_, isDarkMode, __) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RecycleMate',
        theme: isDarkMode
            ? ThemeData.dark().copyWith(
                primaryColor: const Color(0xFFFFFFFF),
                brightness: Brightness.dark,
                appBarTheme: AppBarTheme(color: Colors.green),
                backgroundColor: const Color(0xFF121212),
                scaffoldBackgroundColor: const Color(0xFF121212),
                canvasColor: Colors.green,
              )
            : ThemeData.light().copyWith(
                primaryColor: const Color(0xFFFAFAFA),
                scaffoldBackgroundColor: const Color(0xFFFAFAFA),
              ),
        home: const SplashScreen(),
      ),
    );
  }
}
