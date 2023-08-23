import 'package:flutter/material.dart';
import 'package:exigence_v6/Widgets/map_widget.dart';
import 'package:exigence_v6/Widgets/quickCall_widget.dart';
import 'package:exigence_v6/Actions/shake_detector.dart';
import 'package:exigence_v6/Actions/sms_sender.dart';
import 'package:camera/camera.dart';
import 'package:exigence_v6/Actions/AutoPhotoCapture.dart';

import '../Actions/email_sender.dart'; // Import the PhotoCapture class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;
  ShakeDetector? _shakeDetector;
  late PhotoCapture _photoCapture;

  @override
  void initState() {
    super.initState();
    _initializeCamera().then((_) {
      _initializeShakeDetector();
      _photoCapture = PhotoCapture(_cameraController);
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  void _initializeShakeDetector() {
    _shakeDetector = ShakeDetector(
      onShake: () async {
        _capturePhotoAndSendSMSAndEmail();
        print('Shaking detected!');
      },
    );
    _shakeDetector!.startListening();
  }

  void _capturePhotoAndSendSMSAndEmail() async {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }

    final photoPath = await _photoCapture.captureAndSavePhoto();
    final smsSender = SmsSender();
    smsSender.sendSMS("Hey, are you there? I've captured a photo.");
    print('SMS sent!');

    final emailSender = EmailSender();
    try {
      await emailSender.sendEmailWithAttachment(photoPath);
      print('Email sent with attachment!');
    } catch (e) {
      print('Failed to send email: $e');
    }
  }





  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: MapWidget(),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return QuickCallWidget(phoneNumber: "7008786967");
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
