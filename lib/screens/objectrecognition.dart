/* import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/main.dart';
import 'package:fyp/reusable/colors_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

class ObjRec extends StatefulWidget {
  const ObjRec({super.key});

  @override
  State<ObjRec> createState() => _ObjRecState();
}

class _ObjRecState extends State<ObjRec> {
  bool isWorking = false;
  String result = '';
  CameraImage? imgCamera;
  late CameraController _cameraController;

  loadModel() async {
    await Tflite.loadModel(
        model: "asset/model/recycle_detection_model.tflite",
        labels: "asset/model/labels.txt");
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: imgCamera!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: imgCamera!.height,
          imageWidth: imgCamera!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 5,
          threshold: 0.1,
          asynch: true);

      result = "";

      recognitions!.forEach((response) {
        result += response["label"] +
            "  " +
            (response["confidence"] as double).toStringAsFixed(2) +
            "\n\n";
      });
      if (mounted) {
        setState(() {
          result;
        });
      }

      isWorking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel();

    _checkPermissions();
  }

  initCamera() async {
    try {
      if (cameras.isEmpty) {
        return;
      }
      _cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await _cameraController.initialize().then(
        (value) {
          if (mounted) {
            setState(() {});
          }
        },
      ).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              {
                Fluttertoast.showToast(
                    msg:
                        'Camera Access Denied. Please allow access for camera.',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 18.0);
              }
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });

      if (mounted) {
        setState(() {
          _cameraController.startImageStream(
            (imageFromStream) {
              if (!isWorking) {
                isWorking = true;
                imgCamera = imageFromStream;
                runModelOnStreamFrames();
              }
            },
          );
        });
      }
    } catch (e) {
      String msg = 'Error initializing camera: $e';
      Fluttertoast.showToast(
          msg: msg,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white70);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        backgroundColor: const Color(0xFF9ADE7B),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("99d578"),
            hexStringToColor("71cc49"),
            hexStringToColor("207b25"),
            hexStringToColor("043b05"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: 250,
              child: imgCamera == null
                  ? SizedBox(
                      height: 300,
                      width: 150
                      ,
                    )
                  : AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController),
                    ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 55),
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(
                        backgroundColor: Colors.black87,
                        fontSize: 30,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkPermissions() async {
    PermissionStatus status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      await Permission.camera.request();
    }
    if (await Permission.camera.request().isGranted) {
      initCamera();
    }
  }

  @override
  void dispose() async {
    super.dispose();

    await Tflite.close();
    _cameraController.dispose();
  }
}
 */