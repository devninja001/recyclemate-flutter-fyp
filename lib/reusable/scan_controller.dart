import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    initCamera();

    initTFLite();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  var label = "";

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(cameras[0], ResolutionPreset.max);

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      print("Camera Permission Denied!");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "asset/model/converted_model.tflite",
      labels: "asset/model/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    try {
      var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map(
          (e) {
            return e.bytes;
          },
        ).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 5,
        rotation: 90,
        threshold: 0.8,
      );

      if (detector != null) {
        var detectedObject = detector.first;
        if (detectedObject["confidence"] * 100 > 45) {
          label = detectedObject["label"].toString();
          /* 
        h = detectedObject['rect']["h"];
        w = detectedObject['rect']["w"];
        x = detectedObject['rect']["x"];
        y = detectedObject['rect']["y"]; 
        */
        }
        log("result is $detector");
        update();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  stopCamera() {
    if (isCameraInitialized.value) {
      cameraController.stopImageStream();
      isCameraInitialized(false);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    stopCamera();
    
    await Tflite.close();
    cameraController.dispose();
  }
}
