import 'package:flutter/material.dart';
import 'package:fyp/screens/camera_view.dart';
import 'package:fyp/screens/guides.dart';
import 'package:fyp/screens/home.dart';
import 'package:fyp/screens/settings.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorController = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: navigatorController.selectedIndex.value,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (index) =>
                navigatorController.selectedIndex.value = index,
                shadowColor: Colors.amber,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.menu_book_rounded), label: 'Sorting Guide'),
              NavigationDestination(
                  icon: Icon(Icons.camera_alt_outlined), label: 'Object Sorter'),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ]),
      ),
      body: Obx(() => navigatorController.screens[navigatorController.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [HomePage(), GuidesScreen(), CameraView(), SettingScreen()];
}
