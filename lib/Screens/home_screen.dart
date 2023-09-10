import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../Widgets/quickCall_widget.dart';
import '../Widgets/camera_widget.dart';
import '../Widgets/map_widget.dart';
import 'package:exigence_v6/Actions/shake_detector.dart';
import 'package:exigence_v6/Actions/sms_sender.dart';
import 'package:exigence_v6/Actions/AutoPhotoCapture.dart';
import '../Actions/email_sender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

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
    final List<QuickCallData> quickCallDataList = [
      QuickCallData(phoneNumber: "111", imageAsset: 'assets/images_call/ambulance.png'),
      QuickCallData(phoneNumber: "333", imageAsset: 'assets/images_call/fireBrigade.png'),
      QuickCallData(phoneNumber: "444", imageAsset: 'assets/images_call/police.png'),
      QuickCallData(phoneNumber: "222", imageAsset: 'assets/images_call/childhelpline.png'),
      QuickCallData(phoneNumber: "555", imageAsset: 'assets/images_call/seniorcitizenhelpline.png'),
      QuickCallData(phoneNumber: "666", imageAsset: 'assets/images_call/womenhelpline.png'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: MapWidget(),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Quick Contacts",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: quickCallDataList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: QuickCallWidget(
                      phoneNumber: quickCallDataList[index].phoneNumber,
                      imageAsset: quickCallDataList[index].imageAsset,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickCallData {
  final String phoneNumber;
  final String imageAsset;

  QuickCallData({required this.phoneNumber, required this.imageAsset});
}
