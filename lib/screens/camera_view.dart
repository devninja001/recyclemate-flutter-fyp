// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fyp/reusable/logoutprompt.dart';
import 'package:fyp/reusable/scan_controller.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: const Text(
                      "Object Sorter",
                    ),
                    automaticallyImplyLeading: false,
                    actions: [LogOutPrompt()],
                    backgroundColor: const Color(0xFF99d578),
                  ),
                  body: Stack(
                    children: [
                      CameraPreview(controller.cameraController),
                      Positioned(
                        bottom: 10,
                        left: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            controller.label,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text("Loading Preview..."),
                );
        },
      ),
    );
  }
}
