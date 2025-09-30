import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  @override
  void onInit() {
    super.onInit();
    try {
      _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      log("No Connection!");
      Get.dialog(
          const AlertDialog(
            icon: Icon(Icons.wifi_off_outlined),
            title: Text("No Connection"),
            titleTextStyle: TextStyle(color: Colors.black),
            content: Text("Please check your internet connection!"),
          ),
          barrierDismissible: false);
    } else {
      if (Get.isDialogOpen!) {
        Get.close(1);
      }
    }
  }
}
